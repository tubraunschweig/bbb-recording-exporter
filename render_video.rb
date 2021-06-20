# No deskshare - mouse overlay method
ffmpeg -f lavfi -i color=c=white:s=1920x1080 \
    -f concat -safe 0 -i timestamps/whiteboard_timestamps \
    -framerate 10 -loop 1 -i cursor/cursor.svg \
    -framerate 1 -loop 1 -i chats/chat.svgz \
    -i video/webcams.webm \
    -filter_complex "[2]sendcmd=f=timestamps/cursor_timestamps[cursor];[3]sendcmd=f=timestamps/chat_timestamps,crop@c=w=320:h=840:x=0:y=0[chat];[4]scale=w=320:h=240[webcams];[0][1]overlay=x=320[slides];[slides][cursor]overlay@m[whiteboard];[whiteboard][chat]overlay=y=240[chats];[chats][webcams]overlay" \
    -c:a aac -shortest -y merged.mp4

# With deskshare
ffmpeg -f lavfi -i color=c=white:s=1920x1080 \
    -f concat -safe 0 -i timestamps/whiteboard_timestamps \
    -framerate 10 -loop 1 -i cursor/cursor.svg \
    -framerate 1 -loop 1 -i chats/chat.svgz \
    -i video/webcams.mp4 \
    -i deskshare/deskshare.mp4 \
    -filter_complex "[2]sendcmd=f=timestamps/cursor_timestamps[cursor];[3]sendcmd=f=timestamps/chat_timestamps,crop@c=w=320:h=840:x=0:y=0[chat];[4]scale=w=320:h=240[webcams];[5]scale=w=1600:h=1080:force_original_aspect_ratio=1[deskshare];[0][deskshare]overlay=x=320:y=90[screenshare];[screenshare][1]overlay=x=320[slides];[slides][cursor]overlay@m[whiteboard];[whiteboard][chat]overlay=y=240[chats];[chats][webcams]overlay" \
    -c:a aac -shortest -y merged.mp4


# Sendcmd chat test
ffmpeg -f lavfi -i color=c=white:s=1920x1080 \
    -framerate 1 -loop 1 -i chats/chat.svgz \
    -filter_complex '[1]sendcmd=f=timestamps/chat_timestamps,crop@c=w=320:h=840:x=0:y=0[chat];[0][chat]overlay=y=240' \
    -t 474 -y chat.mp4