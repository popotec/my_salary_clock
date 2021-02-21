# My Salary Clock :  당신만의 월급 시계를 가져보세요
<a href='https://play.google.com/store/apps/details?id=com.broadenway.salary_watch&utm_source=github&utm_campaign=flutter&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/ko/badges/static/images/badges/en_badge_web_generic.png' width="250" height="100"/></a>

### 개발언어
>Flutter 플랫폼 기반의 Dart

### 서비스 지원 플랫폼
>Android (O)
iOS (준비중)


### 기능
>1. 연봉 기준으로 매일 급여를 계산할 수 있습니다. 
>2. 스탑워치를 이용해 특정 시간동안 수행한 일의 가치를 계산할 수 있습니다.

### 기능 소개
1. 초기 설정 : 연봉과 근무시간 입력

<img src="https://images.velog.io/images/jerry92/post/a2450353-3e2d-4ca6-bbfd-76447332f42a/%E1%84%8E%E1%85%A9%E1%84%80%E1%85%B5%E1%84%8B%E1%85%A7%E1%86%AB%E1%84%87%E1%85%A9%E1%86%BC%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8C%E1%85%A5%E1%86%BC.png" width="30%" height="30%"/> <img src="https://images.velog.io/images/jerry92/post/cd329d8f-4437-416b-af78-128c4d61783e/%E1%84%80%E1%85%B3%E1%86%AB%E1%84%86%E1%85%AE%E1%84%89%E1%85%B5%E1%84%80%E1%85%A1%E1%86%AB%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8C%E1%85%A5%E1%86%BC.png" width="30%" height="30%"/>

2. 샐러리 클락 : 일일 급여
- 밀리세컨급여 구하기
> - 주급 : 연봉/52(주)[1년]
	일급 : 주급/근무요일 수
    시급 : 일급/[종료시간-시작시간]
    밀리세컨급여 : 시급/60*60*100= 일급/[종료시간-시작시간]*360000
    
> - 급여계산 : 밀리세컨급여 * (현재시간-시작시간을 밀리세컨초로 환산한 값)
	- 현재시간이 시작시간 전이면 근무를 시작하지 않았기때문에 급여가 0으로 계산됨
	- 현재시간이 종료시간 이후면 종료시간을 기준으로 급여를 계산함

<img src="https://images.velog.io/images/jerry92/post/4e5fe60b-426a-41e9-a7f3-ccabfbfb79d4/%E1%84%8B%E1%85%B5%E1%86%AF%E1%84%8B%E1%85%B5%E1%86%AF%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8B%E1%85%A7.png" width="30%" height="30%"/>



3. 샐러리 스탑워치 : 특정 시간동안 수행한 일을 금액으로 환산
- 앱에서 Provider로 공유되는 밀리세컨급여를 이용하여 금액 계산
- 앱 실행중에는 isolate로 별도의 스레드를 이용해 Timer를 실행함. Timer가 10밀리세컨 주기로 동작하면서 stopwatch에서 측정되는 시간값을 변경해주고 이는 Provider를 통해 notify되면서 화면에 급여가 변하게 됨.
- stopwatch 동작중 앱을 떠났다가[background 상태 혹은 종료] 다시 실행한경우 stopwatch가 계속 돌고 있었던 것처럼 구현하기 위해, WidgetsBindingObserver를 사용함
	- didChangeAppLifecycleState를 override하여 AppLifecycleState.paused 이벤트가 탐지되는 경우, 스탑워치로 측정된 시간, 현재시간, 동작중 혹은 일시정지 상태를 SharedPreference에 기록함
	- AppLifecycleState.resumed 으로 앱이 다시 실행되는경우 SharedPreference에서 기록한 정보를 읽어와 셋팅해주고, 기록당시 시간과 현재시간을 비교하여 그만큼 측정했던 시간에 플러스 함

<img src="https://images.velog.io/images/jerry92/post/80ce62b4-1fd6-40e8-9078-8b32476e8928/%E1%84%89%E1%85%B3%E1%84%90%E1%85%A1%E1%86%B8%E1%84%8B%E1%85%AF%E1%84%8E%E1%85%B5%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8B%E1%85%A7.png" width="30%" height="30%"/>
