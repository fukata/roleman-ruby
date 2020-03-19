# roleman-ruby

## これは何？

ビューやコントローラに散らばった権限チェックのコードを集約するためのもの。

とりあえず、Railsで使用されることを前提に実装する。

## 願望

- ビューやコントローラに散らばった権限チェックのコードを集約したい。
- さらに、権限管理を設定ファイル（多いと結局見にくいため）をエクセルなどの表で管理したい。
- それをプログラムが利用可能な形式にエクスポートできるようにする。


## 実装案

### 設定方法

下記はプログラムが使用する前段階の人間が管理する形式をイメージした表。

エクセルやマークダウンで記入させてもよいかもしれない。

| Path                 | Read | Edit | Admin |
| -------------------- | ---- | ---- | ----- |
| GET /                | x    | x    | x     |
| GET /items/:id       | x    | x    | x     |
| GET /items/:id/edit  | -    | x    | x     |
| PUT /items/:id       | -    | x    | x     |

### 設定ファイル

上記の表から生成される想定のYAML。プログラムはこれを読み込む。

```yaml
--
roleman:
  version: 1
  paths:
    - path: /
      method: GET
      enabled_roles:
        - Read
        - Edit
        - Admin
    - path: /items/:id
      method: GET
      enabled_roles:
        - Read
        - Edit
        - Admin
    - path: /items/:id/edit
      method: GET
      enabled_roles:
        - Edit
        - Admin
      disabled_roles:
        - Read
    - path: /items/:id
      method: PUT
      enabled_roles:
        - Edit
        - Admin
      disabled_roles:
        - Read
```

### Railsのルーティングから表を生成

既存のプロジェクトに導入する事が多いと思われるのでRailsのルーティング設定から上記の表を生成する機能は欲しい。

### 単純な権限以外での認証

user.role = `Read` or `Edit` or `Admin`

みたいな状態の時にユーザーオブジェクトとリクエストパスを見てチェック。がデフォルトの挙動だけど場合によってはもう少し踏み込んだチェックをしたいこともあるだろう。

例えば、特定のオブジェクトの所有者と現在アクセス中のユーザーの一致を判定する等。

ただしこれはエクセルに埋め込めないので `config/initializers/roleman.rb` などで設定してもらう？

### 設定されていないパスの場合例外にするオプション

設定されていないパスの場合、例外を投げるオプションを設ける。

これにより開発環境やテスト環境で未設定のパスの検出がしやすくなる。