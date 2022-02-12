# Tastie Infrastructure

테이스티 서비스에 필요한 인프라를 프로비저닝하기 위한 테라폼 라이브 레포입니다.

## Getting started

### 테라폼 버전

해당 테라폼 레포는 1.1.5 테라폼 버전을 사용합니다.

### 테라폼 클라우드 로그인

해당 레포는 리모트 스테이트를 저장하기 위한 테라폼 백엔드로 테라폼 클라우드를 사용하므로 테라폼 클라우드 로그인이 필요합니다.

```sh
$ terraform login app.terraform.io
```

### AWS 인증 토큰 설정

iam으로 부터 aws 액세스 토큰과 시크릿 토큰을 발급받아 aws 환경변수를 셋업합니다.

```sh
export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION=ap-northeast-2 # apprunner와 ecr에서는 ap-northeast-1
```

### 1. terraform init

각 프로젝트에서 먼저 terraform init을 해야합니다.
terraform init을 성공적으로 마치면 테라폼 클라우드에 워크스페이스가 생성이 되고
테라폼 클라우드의 워크스페이스 general 설정에 가서 Execution Mode를 Remote에서 Local로 변경해줍니다.

```sh
$ terraform init
```

## 테라폼 디렉토리

### ECR(ap-northeast-2/ecr)

도커 이미지를 푸시할 수 있는 AWS ECR 레포를 관리하는 디렉토리입니다.
app runner와 연결하기 위해 일본 리전에 생성합니다.

### RDS(ap-northeast-2/rds/prod)

프로덕션 데이터베이스를 띄울 수 있는 디렉토리입니다.
생성하기 전에 [aws 파라미터 스토어](https://ap-northeast-2.console.aws.amazon.com/systems-manager/parameters/?region=ap-northeast-2&tab=Table)에 아래의 경로로 인증값을 사전에 셋업해줘야합니다.

/apprunner/alpha/backend/DB_USERNAME: db 유저네임
/apprunner/alpha/backend/DB_PASSWORD: db 패스워드

### App Runner(ap-northeast-2/apprunner/alpha/backend)

메인 앱을 동작시킬 aws 서비스입니다.
apprunner.tf에 앱 러너 설정 중 image_identifier 값을 생성된 ECR URL로 바꿔줍니다.
apprunner는 현재 서울 리전에서 지원하지 않으므로 일본 리전으로 생성합니다.

## Github Action secret 설정

백엔드 레포에서 디폴트 브랜치로 푸시가 되면 백엔드 레포 액션에서 도커 이미지를 빌드하고 ecr로 푸시까지 진행합니다.
이후에 해당 레포로 배포를 위한 PR을 자동으로 만들게 되는데 이 때 PR을 통해 동작하는 배포 액션이 테라폼 plan와 apply를
진행하기 때문에 github action secret 설정에 테라폼 클라우드 API Key와 AWS 관련 인증 토큰이 필요합니다.

### 필요한 secret들

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- TF_API_TOKEN # 테라폼 클라우드에서 발급

## 배포 프로세스

1. 백엔드 레포에서 메인 브랜치로 푸시
2. 백엔드 레포 액션에서 이미지 빌드 및 푸시
3. 백엔드 레포 액션에서 infra 레포에 PR 생성
4. infra 레포 PR에서 테라폼 플랜 수행
5. 리뷰 후 action approve를 눌러 terraform apply까지 수행

infra 레포를 프라이빗으로 변경하면 action의 approve 기능 사용 불가능
