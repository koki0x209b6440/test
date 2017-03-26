# Sudoku
Tool for Sudoku (with Processing)

![pv](https://raw.githubusercontent.com/turanegaku/Sudoku/data/m1.gif)

[実行ファイル(bin.zip)](https://github.com/turanegaku/Sudoku/blob/data/bin.zip?raw=true)

# 概要
#### 数独を解くときの補助ツール
- 各セル毎に1-9の可能性を保持し，それを付けたり消したりできる
- 確定したセルの数字は大きく表示する
- チェックを行うと盤面が正しいか正しくないかを表示する

#### 数独の解を求めるツール
- 消去法で候補を絞った後に全探索を行ない解を求める

## 操作(キー)
### [←↑→↓hjkl]
対象のセルを移動
### [0 - 9]
対象のセルをその数字で確定する
### Shift + [0 - 9]
その数字の可能性をトグルする
### BACKSPACE
対象のセルをリセットする
### DELETE
全てのセルをリセットする
### [c]
盤面が正しいかどうかをチェックする
### [qwert]
サンプル問題(易 < qwert < 難)
### ENTER
数独を解く
### Control + ENTER
消去法だけ行なう

## 操作(マウス)
### セルをクリック
クリックしたセルを対象のセルにする
### 対象のセルの数字をクリック
その数字の可能性をトグルする
### 下の灰色部分をクリック
数独を解く
