;
; TacOS Source Code
;    Tokuyama kousen Advanced educational Computer
;
; Copyright (C) 2016 by
;                      Dept. of Computer Science and Electronic Engineering,
;                      Tokuyama College of Technology, JAPAN
;
;   上記著作権者は，Free Software Foundation によって公開されている GNU 一般公
; 衆利用許諾契約書バージョン２に記述されている条件を満たす場合に限り，本ソース
; コード(本ソースコードを改変したものを含む．以下同様)を使用・複製・改変・再配
; 布することを無償で許諾する．
;
;   本ソースコードは＊全くの無保証＊で提供されるものである。上記著作権者および
; 関連機関・個人は本ソースコードに関して，その適用可能性も含めて，いかなる保証
; も行わない．また，本ソースコードの利用により直接的または間接的に生じたいかな
; る損害に関しても，その責任を負わない．
;

; lib/io.s : 入出力関数
;
; 2016.01.10 新規作成
;
; $Id$
;

;; CPU を停止
_halt
        halt

;; ワード(16bit)を I/O ポートから入力する
_in                         ; int in(int p);
        ld      g1,2,sp     ; ポートアドレス
        in      g0,g1       ; I/O ポートから入力する
        ret

;; ワードを I/O ポートへ出力する 
_out                        ; void out(int p,int v);
        ld      g0,2,sp     ; ポートアドレス
        ld      g1,4,sp     ; 出力データ
        out     g1,g0       ; I/O ポートへ出力する
        ret
