# **************************************************************************** #
#                                                                              #
#   .__                 __         .__  .__                                    #
#   |__| ____   _______/  |______  |  | |  |                                   #
#   |  |/    \ /  ___/\   __\__  \ |  | |  |           :::      ::::::::       #
#   |  |   |  \\___ \  |  |  / __ \|  |_|  |__       :+:      :+:    :+:       #
#   |__|___|  /____  > |__| (____  /____/____/     +:+ +:+         +:+         #
#           \/     \/            \/              +#+  +:+       +#+            #
#     ____ _____    ______ _____               +#+#+#+#+#+   +#+               #
#    /    \\__  \  /  ___//     \                   #+#    #+#                 #
#   |   |  \/ __ \_\___ \|  Y Y  \                 ###   ########   seoul.kr   #
#   |___|  (____  /____  >__|_|  /                                             #
#        \/     \/     \/      \/                                              #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# 변수 기본값
INSTALL_PATH="$HOME/goinfre"

# 옵션 적용
GETOPT_TEMP=$(getopt --options 'av::p:' --longoptions 'always,version::,path::' --name $0 -- "$@")
if [ $? -ne 0 ]; then
	exit 1
fi
eval set -- "$GETOPT_TEMP"
unset GETOPT_TEMP
while true; do
	case "$1" in
		'-a'|'--always')
			ALWAYS=1
			shift
			continue
		;;
		'-p'|'--path')
			INSTALL_PATH="$2"
			shift 2
			continue
		;;
		'-v'|'--version')
			case "$2" in
				'')
					shift 2
				;;
				*)
					NASM_VERSION="$2"
					shift 2
				;;
			esac
			continue
		;;
		'--')
			shift
			break
		;;
		*)
			exit 1
		;;
	esac
done

# 절대 경로로 변환
INSTALL_PATH="$(realpath "$INSTALL_PATH")"

# 이미 설치 경로가 존재하는 경우 PATH 환경변수 안내, always 옵션으로 무시
if test -z "$ALWAYS" && test -e "$INSTALL_PATH"; then
	echo PATH='$PATH':"$INSTALL_PATH"/bin
	exit
fi

# 실행 중 종료 코드가 0이 아닌 명령 발생시 스크립트 종료, 실행 명령 출력
set -o errexit
set -o xtrace

# 설치를 위한 임시 디렉토리 할당 및 종료시 해제 트랩 설정
TEMPORARY_DIRECTORY="$(mktemp --directory)"
rmtemp() {
	rm --force --recursive -- "$TEMPORARY_DIRECTORY"
}
cd -- "$TEMPORARY_DIRECTORY"
trap 'rmtemp' EXIT

# 다운로드
if test -z "$NASM_VERSION"; then
	# 버전을 명시하지 않은 경우 stable 경로 순회하여 탐색
	wget --execute robots=off --no-directories --recursive --level=1 --accept "*.xz" --reject "*xdoc*" --relative --no-parent --reject-regex "\?|\/$" https://www.nasm.us/pub/nasm/stable/

	ARCHIVE_NAME="$(ls *.tar.xz)"
	NASM_NAME="$(basename --suffix=.tar.xz $ARCHIVE_NAME)"
else
	# 버전을 명시한 경우 명시적인 경로에서 탐색
	NASM_NAME="nasm-$NASM_VERSION"
	ARCHIVE_NAME="$NASM_NAME.tar.xz"
	wget "https://www.nasm.us/pub/nasm/releasebuilds/$NASM_VERSION/$ARCHIVE_NAME"
fi
# 설치
tar --extract --file="$ARCHIVE_NAME" --xz
cd -- "$NASM_NAME"
mkdir --parents -- "$INSTALL_PATH"
./configure --prefix="$INSTALL_PATH"
make --jobs install

echo PATH='$PATH':"$INSTALL_PATH"/bin
