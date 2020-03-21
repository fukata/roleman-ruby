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
  routes:
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

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roleman'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install roleman

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fukata/roleman. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/fukata/roleman/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Roleman project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fukata/roleman/blob/master/CODE_OF_CONDUCT.md).
