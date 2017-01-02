/*
 * TacOS Source Code
 *    Tokuyama kousen Advanced educational Computer
 *
 * Copyright (C) 2008-2016 by
 *                      Dept. of Computer Science and Electronic Engineering,
 *                      Tokuyama College of Technology, JAPAN
 *
 *   上記著作権者は，Free Software Foundation によって公開されている GNU 一般公
 * 衆利用許諾契約書バージョン２に記述されている条件を満たす場合に限り，本ソース
 * コード(本ソースコードを改変したものを含む．以下同様)を使用・複製・改変・再配
 * 布することを無償で許諾する．
 *
 *   本ソースコードは＊全くの無保証＊で提供されるものである。上記著作権者および
 * 関連機関・個人は本ソースコードに関して，その適用可能性も含めて，いかなる保証
 * も行わない．また，本ソースコードの利用により直接的または間接的に生じたいかな
 * る損害に関しても，その責任を負わない．
 *
 *
 */

/*
 * util/util.h : util.cmm の外部インターフェイス
 *
 * 2016.01.19 : WordLE を wordLE に変更
 * 2016.01.18 : WordBE と stWordBE を削除
 * 2016.01.11 : 一部の関数をキャメルケースに統一
 * 2016.01.05 : isUpper, isLower, isDigit, isPrint をマクロに変更
 * 2015.12.21 : _uCmp32() を追加
 * 2015.12.14 : strncpy() を dirAccess に移植
 * 2015.09.07 : strlen(), strcpy() を追加, MEM 配列を復活(重村)
 * 2015.08.19 : ワード処理ルーチンを移植
 * 2014.05.07 : 村田開発開始
 * 2013.01.06 : MEM を削除
 * 2012.12.27 : isUpper, isLower, isDigit, isPrint を追加
 * 2012.03.02 : crt0.h を分離
 * 2012.03.02 : TeC7 用に書き換える
 * 2011.05.26 : TaC-OS に不要なものを削除
 * 2011.05.23 : MEM 配列を追加
 * 2011.05.12 : panic 関数を追加
 * 2010.07.20 : Subversion による管理を開始
 * 2010.03.12 : public 修飾子を追加
 * 2009.11.05 : バイト配列関係の関数を追加
 * 2009.11.05 : Kernel 用と Boot 用をマージしなおす
 * 2009.04.16 : Boot 用に書き換え
 * 2008.08    : Kernel 用の初期バージョン
 *
 * $Id$
 *
 */

#include "crt0.h"

public char[] MEM;       // 主記憶を意味する配列 utilInit() で 0x0000 に初期化

public void utilInit();
public int _uCmp32(int[] a, int[] b);
public char toUpper(char c);
public int strLen(char[] s);
public char[] strCpy(char[] dst, char[] src);
public void putCh(char c);
public void putStr(char[] str);
public void panic(char[] msg, ...);


/*
 * SIO 等で使用できるリングバッファと管理ルーチン
 */

// リングバッファ型
struct RingBuf {
  char[] buf;                             // バッファ
  int    head, tail;                      // ポインタ
};


#define  BSIZE   256
// リングバッファは空か
#define ISEmpty(buf) ((buf).head==(buf).tail)
// リングバッファは満か
#define ISFull(buf) (nextIdx((buf).head)==(buf).tail)

public int nextIdx(int idx);
public int prevIdx(int idx);
public boolean putBuf(RingBuf buf, char c);
public char getBuf(RingBuf buf);

#define isDigit(c) (ord('0')<=ord(c) && ord(c)<=ord('9'))
#define isLower(c) (ord('a')<=ord(c) && ord(c)<=ord('z'))
#define isUpper(c) (ord('A')<=ord(c) && ord(c)<=ord('Z'))
#define isPrint(c) (0x20<=ord(c) && ord(c)<=0x7e)

// char 配列に格納された、リトルエンディアンの Word データをアクセスする
// (FAT ファイルシステムから読み込んだものがリトルエンディアン)
#define wordLE(b, i) ((ord((b)[(i)+1])<<8) | ord((b)[i]))
#define stWordLE(b,i,s) {(b)[i]=chr(s); b[(i)+1]=chr((s)>>8);}

#ifdef DEBUG
public int printF(char[] fmt, ...);
#endif
