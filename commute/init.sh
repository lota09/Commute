# 비정상 종료 시 경고 메시지를 출력하는 함수 정의
function on_exit {
    kill $pid1 $pid2 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Warning: Script terminated with a non-zero exit status."
    fi
}

trap on_exit EXIT   # 스크립트 종료 시 on_exit 실행


pkill -f "smartthings edge:drivers:logcat"
mv './logs/raw.log' "./logs/raw $(date +'%Y-%m-%d %H%M%S').log"

# 백그라운드 프로세스 1 시작
smartthings edge:drivers:logcat 572a2641-2af8-47e4-bfe5-ad83748fd7a1 >> ./logs/raw.log &
pid1=$!

# 백그라운드 프로세스 2 시작
python3 commute.py &
pid2=$!

# 모든 백그라운드 프로세스가 완료될 때까지 대기
wait $pid1
wait $pid2

echo "Commute recorder is now terminated."
exit 0

