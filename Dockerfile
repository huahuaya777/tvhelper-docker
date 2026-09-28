FROM wukongdaily/box@sha256:cf8384151c3face7fe51d55a8898b034d4a00dd71e0b6793a5464d2fe84b5066

COPY shells/tv.sh /tvhelper/shells/tv.sh
COPY shells/tv.sh /usr/local/bin/t

RUN chmod +x /tvhelper/shells/tv.sh /usr/local/bin/t
