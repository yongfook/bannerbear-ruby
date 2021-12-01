# Bannerbear

Ruby wrapper for the [Bannerbear API](https://developers.bannerbear.com) - an image and video generation service.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bannerbear'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bannerbear

## Usage

### Create the Client

Get the API key for your project in Bannerbear and create a client.

```ruby
bb = Bannerbear::Client.new("your API key")
```

Alternatively you can place your API key in an ENV variable named `BANNERBEAR_API_KEY` and create the client:

```ruby
bb = Bannerbear::Client.new
```

### Create an Image

To create an image you reference a template uid and a list of modifications. The default is async generation meaning the API will respond with a `pending` status and you can use the `get_image` method to retrieve the final image.

```ruby
bb.create_image("template uid", :modifications => [
  {
    :name => "headline",
    :text => "Hello World!"
  },
  {
    :name => "photo",
    :image_url => "https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=1000&q=80"
  }
])
```

You can also create images synchronously - this will take longer to respond but the image will be delivered in the response:

```ruby
bb.create_image("template uid", :synchronous => true, :modifications => [
  {
    :name => "headline",
    :text => "Hello World!"
  },
  {
    :name => "photo",
    :image_url => "https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=1000&q=80"
  }
])
```

#### Options

- `modifications`: an array of [modifications](https://developers.bannerbear.com/#post-v2-images) you would like to make (`array`)
- `webhook_url`: a webhook url to post the final image object to (`string`)
- `transparent`: render image with a transparent background (`boolean`)
- `render_pdf`: render a PDF in addition to an image (`boolean`)
- `metadata`: include any metadata to reference at a later point (`string`)

### Get an Image

```ruby
bb.get_image("image uid")
```

### List all Images

```ruby
bb.list_images
```

```ruby
bb.list_images(:page => 10)
```

#### Options

- `page`: pagination (`integer`)
- `limit`: return n images per page (`integer`)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yongfook/bannerbear-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yongfook/bannerbear-ruby/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bannerbear project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bannerbear/blob/master/CODE_OF_CONDUCT.md).
