ss, sr -- 標準入力を利用した Tac へのファイル送信機能

  ss と sr は、 GNU Screen などを介して Tac にファイルを送信するためのコマンドで、 ss が送信側、 sr が受信側です。 10kB のファイルを約 15 秒程度で送信することができます。

使い方

1. Tac を PC に接続します。

2. GNU Screen を起動します。

  $ screen /dev/tty.u[TAB]

3. Tac 上で sr を起動します。

  $ sr

4. screen 上で「[Ctrl+A]:exec !! ss.sh [送信したいファイル名] [送信先のパス]」 と入力します。
  [Ctrl+A] は screen のエスケープキーです。

  例:
  : exec !! ss.sh TacOS/uSD/bin/hello.exe /bin/hello.exe

5. 暫く待ちます。

6. screen を [Ctrl+A][Ctrl+\] で一旦終了し、また起動します。

7. Tac の RESET ボタンを押します。
