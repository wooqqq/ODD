<div align="center">

<img width="300px" src="https://github.com/user-attachments/assets/679132d6-1ed9-4522-9d33-afbc5db6f868" />

<br>

<h2>삼성 청년 SW 아카데미 11기 자율 GS리테일 기업연계 S105</h2>

<p>
    편의점/슈퍼 배달/픽업 고객 대상 재구매 상품 추천 서비스 개발
</p>

<br/>
<br/>

</div>


<div>


## 🎈 프로젝트 개요

우리동네단골은 재구매 기반 추천 알고리즘 앱 및 관리를 위한 대시보드 서비스입니다.  

본 프로젝트는 '우리동네GS'를 기반으로 사용자의 행동 데이터를 바탕으로 개인화 맞춤형 재구매 추천 서비스를 제공합니다.    

개선된 앱의 UI/UX를 통해 사용자의 편리성을 더해주며 추천을 효율적으로 제공하고 있습니다.

앱의 데이터를 관리자를 위하여 시각화하는 대시보드를 제공합니다.

<br/>


<h2>📅 개발 기간</h2>
 2024.10.12 ~ 2024.11.19  
 
</div>


</div>

<br/>
<br/>

<!-- 기술 스택 -->



## 📌 주요 기능

- **시간대 기반 재구매 추천 알고리즘**  
: 사용자가 각 시간대별로 90일 이내에 3회 이상 구매 행동을 보인 시간대를 찾아 적합한 상품을 추천하는 알고리즘  

- **구매 주기 기반 재구매 추천 알고리즘**  
: 재구매 주기를 학습하고 분석하여 사용자에게 적절한 시점에 상품을 추천하는 알고리즘 (재구매 주기가 45일 이상인 경우 90%, 미만인 경우 80% 경과 후 재구매 추천 시작)  

- **추천 카테고리 기반 재구매 추천 알고리즘**  
: 신규 사용자에게는 회원가입 시 대분류 선호 카테고리를 입력받고, 유사한 사용자들이 많이 구매한 상품을 카테고리 기반 사용자 협업 필터링을 통해 추천하는 알고리즘  
: 기존 사용자의 행동 데이터를 분석하여 소분류 선호 카테고리를 계속해서 업데이트하여, 같은 카테고리 내 유사 상품 (콘텐츠 기반 알고리즘)과 같은 카테고리를 선호하는 다른 사용자들이 선호하는 상품을 추천(카테고리 기반 사용자 협업 필터링)하는 하이브리드 모델의 알고리즘  

- **데이터 시각화를 위한 대시보드**  
: 전체 사용자 및 상품에 대하여 재구매 사용자 수, 성별&나이, 상품 리스트 카테고리별 조회 수, 장바구니 수, 주문 수 시각화  

- **개인 데이터 시각화를 위한 정성 평가 대시보드**  
: 사용자 개인의 상세 조회, 장바구니, 구매 등의 로그 확인 및 개인화 추천 상품 조회 대시보드

<br/>

## 🛠 기술 고도화

- **Elasticsearch**

  - 검색 엔진 최적화
  - 음절 단위 역 색인을 통한 통합 검색 엔진 지원

- **캐시 사용**

  - real-time에 대해서 반복적인 update 발생

<br/>

## 📞 우리동네단골 APP
  
  : 사용자의 편리함을 극대화 시키는 UI/UX 구상

| 로그인 페이지                        | 회원가입 페이지                             | 선호태그                                |
| ------------------------------------ | ------------------------------------------- | --------------------------------------- |
| ![login_page](https://github.com/user-attachments/assets/5e552aec-1247-404f-93eb-9c90308a6654) | ![register_page](https://github.com/user-attachments/assets/be5e5b37-10d8-4c15-be3f-7136b398623d) | ![fav_tag](https://github.com/user-attachments/assets/a59fbf80-3e3f-45ca-8ac7-0cebfde81fee) |  

| 홈페이지                             | 검색 페이지                                 | 검색 결과 페이지                        |
| ------------------------------------ | ------------------------------------------- | --------------------------------------- |
| ![image.png](https://github.com/user-attachments/assets/4c163add-73d3-4412-a49c-663d29c65c70) | ![image.png](https://github.com/user-attachments/assets/d5870256-8b98-48e9-8781-63421d62cabd) | ![image.png](https://github.com/user-attachments/assets/94e28acc-01c7-403a-bf5e-874b31fc8b97) |  

| GS25탭 페이지                        | GS더프레시탭 페이지                         | wine25탭 페이지                         |
| ------------------------------------ | ------------------------------------------- | --------------------------------------- |
| ![image.png](https://github.com/user-attachments/assets/62fe115c-7c8a-488c-8083-c572a7aeefc9) | ![image.png](https://github.com/user-attachments/assets/0dd997c0-b07e-4cf4-b917-e944c5aea11d) | ![image.png](https://github.com/user-attachments/assets/3a78d98d-44e3-4303-9a59-d9f509c73cf3) |

<br/>

## 📊 관리자 대시보드 WEB

**[ 로그인 페이지 ]**  

![login](https://github.com/user-attachments/assets/8f9c6052-c56c-48ee-82ce-b82f9000a16d)

<br/>

**[ 대시보드 페이지 ]**  

![dashboard](https://github.com/user-attachments/assets/7d1003bb-7720-433e-a7d6-495d5a661e3f)

<br/>

**[ 정성 평가 페이지 ]**  

![evaluation](https://github.com/user-attachments/assets/a15c8a27-7d60-46f5-83b7-9a1779cf6e01)

<br/>


## 🐳 System Architecture

![system_architecture](https://github.com/user-attachments/assets/cacdc90c-d0d7-4c5f-8281-c0d89e65cfa5)

<br/>  
    
<br/>

  <h2>🛠 Tech Stack</h2>

<h3>Backend</h3>
<div>
    <img src="https://img.shields.io/badge/java-3578E5?style=for-the-badge&logo=java&logoColor=white" />
    <img src="https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white" />
    <img src="https://img.shields.io/badge/jpa-FF7800?style=for-the-badge&logo=hibernate&logoColor=white" />
    <img src="https://img.shields.io/badge/spring%20security-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white" />
    <img src="https://img.shields.io/badge/firebase-DD2C00?style=for-the-badge&logo=firebase&logoColor=white" />
    <img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
    <img src="https://img.shields.io/badge/fastapi-009688?style=for-the-badge&logo=fastapi&logoColor=white" />
</div>
<h3>Frontend</h3>
<div>
    <img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
    <img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
    <img src="https://img.shields.io/badge/React-0088CC?style=for-the-badge&logo=react&logoColor=white" />
    <img src="https://img.shields.io/badge/javascript-F7DF1E.svg?style=for-the-badge&logo=javascript&logoColor=white" />
    <img src="https://img.shields.io/badge/getX-8A2BE2?style=for-the-badge&logo=getx&logoColor=white">
    <img src="https://img.shields.io/badge/zustand-221E68?style=for-the-badge&logo=react&logoColor=white">
    <img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=HTML5&logoColor=white">
    <img src="https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=CSS3&logoColor=white">
</div>
<h3>Data</h3>
<div>
    <img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white" />
    <img src="https://img.shields.io/badge/mongodb-47A248?style=for-the-badge&logo=mongodb&logoColor=white" />
    <img src="https://img.shields.io/badge/redis-FF4438?style=for-the-badge&logo=redis&logoColor=white " />
    <img src="https://img.shields.io/badge/cassandra-1287B1?style=for-the-badge&logo=apache-cassandra&logoColor=white " />
    <img src="https://img.shields.io/badge/spark-E25A1C?style=for-the-badge&logo=apache-spark&logoColor=white " />
    <img src="https://img.shields.io/badge/elasticsearch-005571?style=for-the-badge&logo=elasticsearch&logoColor=white " />
</div>
<h3>Infra</h3>
<div>
    <img src="https://img.shields.io/badge/amazon%20ec2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white" />
    <img src="https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
    <img src="https://img.shields.io/badge/jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white" />
    <img src="https://img.shields.io/badge/nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" />
</div>

<br/>
<br/>  
<br/>   


<div>
<h2>🧑‍ 팀원 소개</h2>

<div>
<table>
    <tr>
        <td align="center">
        <a href="https://github.com/sommnee">
          <img src="https://avatars.githubusercontent.com/sommnee" width="120px;" alt="wooqqq">
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/wooqqq">
          <img src="https://avatars.githubusercontent.com/wooqqq" width="120px;" alt="Basaeng">
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/player397">
          <img src="https://avatars.githubusercontent.com/player397" width="120px;" alt="jiwon718">
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/seungminleeee">
          <img src="https://avatars.githubusercontent.com/seungminleeee" width="120px;" alt="KBG1">
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/JinAyeong">
          <img src="https://avatars.githubusercontent.com/JinAyeong" width="120px;" alt="taessong">
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/chajoyhoi">
          <img src="https://avatars.githubusercontent.com/chajoyhoi" width="120px;" alt="hhsssu">
        </a>
      </td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/sommnee">
        이소민
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/wooqqq">
        우혜지
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/player397">
        최승탁
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/seungminleeee">
        이승민
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/JinAyeong">
        진아영
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/chajoyhoi">
        차유림
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
        팀장, BE
    </td>
    <td align="center">
      BE
    </td>
    <td align="center">
      Infra, BE
    </td>
    <td align="center">
      FE
    </td>
    <td align="center">
      FE
    </td>
    <td align="center">
      FE
    </td>
  </tr>
</table>
</div>
