/*
 * TacOS Source Code
 *    Tokuyama kousen Advanced educational Computer.
 *
 * Copyright (C) 2011 - 2016 by
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
 * pm/exeFile.h : 実行ファイルフォーマットに関するデータを含むファイル
 *
 * 2016.10.07 : 実行ファイル（EXE ファイル）のマジックナンバーの種類を追加（隅田）
 * 2015.09.08 : ファイルフォーマットに関するコメント追加
 * 2015.08.20 : 新規作成
 *
 * $Id$
 *
 */

#define USERMAGIC  0x0108
#define KERNMAGIC  0x0109
#define HDRSIZ  12

/* 実行ファイル(EXE ファイル)のヘッダを構造体で表現すると
struct ExeHeader {
  int  magic;             // MAGIC コード (0x0108 もしくは 0x0109)
  int  textSiz;           // TEXT  セグメントのサイズ
  int  dataSiz;           // DATA  セグメントのサイズ
  int  bssSiz;            // BSS   セグメントのサイズ
  int  relSiz;            // 再配置情報のサイズ
  int  userStkSiz;        // プロセスのユーザスタックサイズ
}
*/
