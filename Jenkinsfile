pipeline {
    agent any

    tools {
        maven 'Maven 3.9.8'
    }

    environment {
        IMAGE_NAME = 'spring-boot-testing'
        IMAGE_TAG  = '0.0.8'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Mengambil kode dari GitHub...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Menjalankan unit test dan build JAR...'
                sh 'mvn clean package'

                echo 'Membangun Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Test') {
            steps {
                echo 'Menjalankan container untuk smoke test...'
                sh 'docker compose up -d'

                echo 'Menjalankan smoke test...'
                sh 'chmod +x test.sh && ./test.sh'
            }
            post {
                always {
                    echo 'Membersihkan container test...'
                    sh 'docker compose down'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Menyalin docker-compose ke server...'
                sh '''
                    scp -o StrictHostKeyChecking=no \
                        -o ProxyJump=root@server-proxmox \
                        docker-compose.yml \
                        root@10.1.49.196:/root/spring-boot-testing/
                '''
                echo 'Menjalankan aplikasi di server...'
                sh '''
                    ssh -o StrictHostKeyChecking=no \
                        -o ProxyJump=root@server-proxmox \
                        root@10.1.49.196 \
                        "cd /root/spring-boot-testing && docker compose up -d"
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline berhasil! Aplikasi berjalan di 10.1.49.196:9090'
        }
        failure {
            echo 'Pipeline gagal! Periksa log di atas.'
        }
    }
}
