#!/bin/sh

if [ $1 == "lofi" ]; then
	/usr/local/icecast/bin/stream-db.pl
	exit 0
elif [ $1 == "hifi" ]; then
	/usr/local/icecast/bin/stream-db.pl
	exit 0
elif [ $1 == "dev" ]; then
	/home/brian/cvspub/streamcast/streamcast.pl \
	-s localhost -p ungabunga \
	-n "KPRI - Test Stream" -P 8000 -m "/local" \
	-u "http://www.sunset-cliffs.org/kpri" -g "Mish-Mash" -r -D;
	exit 0
elif [ $1 == "moredev" ]; then
	/home/brian/cvspub/streamcast/streamcast.pl \
	-s localhost -p ungabunga \
	-n "KPRI - Test Stream" -P 8000 -m "/local" \
	-u "http://www.sunset-cliffs.org/kpri" -g "Mish-Mash" -r -D -D;
	exit 0
#elif [ $1 == "db" ]; then
#	/home/brian/cvspub/stream-db/stream-db.pl \
#	-s localhost -p ungabunga \
#	-n "KPRI - Test Stream" -P 8000 -m "/local" \
#	-u "http://www.sunset-cliffs.org/kpri" -g "Mish-Mash" -r -D;
#	exit 0
elif [ $1 == "db" ]; then
	/home/brian/cvspub/stream-db/stream-db.pl
	exit 0
elif [ $1 == "one" ]; then
	/usr/local/icecast/bin/streamcast.pl \
	-s localhost -p ungabunga \
	-n "KPRI - Test Stream" -P 8000 -m "/local" \
	-u "http://www.sunset-cliffs.org/kpri" -g "Mish-Mash" -r -D \
	-F /home/ftp/other/misc/extra/Chef-Chocolate_Salty_Balls.mp3;
	exit 0
fi
