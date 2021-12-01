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

### Table of Contents

- [Authentication](#authentication)
- [Account Info](#account-info)
- [Images](#images)
- [Videos](#videos)
- [Collections](#collections)
- [Animated Gifs](#animated-gifs)
- [Movies](#movies)
- [Screenshots](#screenshots)
- [Templates](#templates)
- [Template Sets](#template-sets)
- [Video Templates](#video-templates)

### Authentication

Get the API key for your project in Bannerbear and create a client.

```ruby
bb = Bannerbear::Client.new("your API key")
```

Alternatively you can place your API key in an ENV variable named `BANNERBEAR_API_KEY` and create the client:

```ruby
bb = Bannerbear::Client.new
```

### Account Info

Return info about the Account / Project associated with this API key.

```ruby
bb.account
```

### Images

To create an image you reference a template uid and a list of modifications. The default is async generation meaning the API will respond with a `pending` status and you can use `get_image` to retrieve the final image.

```ruby
bb.create_image("template uid", 
  :modifications => [
    {
      :name => "headline",
      :text => "Hello World!"
    },
    {
      :name => "photo",
      :image_url => "https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=1000&q=80"
    }
  ]
)
```

You can also create images synchronously - this will take longer to respond but the image will be delivered in the response:

```ruby
bb.create_image("template uid", 
  :synchronous => true, 
  :modifications => [
    {
      :name => "headline",
      :text => "Hello World!"
    },
    {
      :name => "photo",
      :image_url => "https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=1000&q=80"
    }
  ]
)
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

### Videos

To create a video you reference a *video template uid*, an input media and a list of modifications. Videos are created async - use `get_video` to retrieve the final video. 

```ruby
bb.create_video("video template uid", 
  :input_media_url => "https://www.yourserver.com/videos/awesome_video.mp4", 
  :modifications => [
    {
      :name => "headline",
      :text => "Hello World!"
    }
  ]
)
```

#### Options

- `input_media_url`: a url to a publicly available video file you want to import (`string`)
- `modifications`: an array of modifications you would like to make to the video overlay (`array`)
- `webhook_url`: a webhook url to post the final video object to (`string`)
- `blur`: blur the imported video from 1-10 (`integer`)
- `trim_to_length_in_seconds`: trim the video to a specific length (`integer`)
- `create_gif_preview`: create a short preview gif (`boolean`)
- `metadata`: include any metadata to reference at a later point (`string`)

If your video is using the "Multi Overlay" build pack then you can pass in a set of frames to render via:

- `frames`: an array of sets of `modifications` (`array`)
- `frame_durations`: specify the duration of each frame (`array`)

### Get a Video

```ruby
bb.get_video("video uid")
```

### List all Videos

```ruby
bb.list_videos
```

#### Options

- `page`: pagination (`integer`)

All other objects on Bannerbear follow a similar pattern to the above core image and video objects.

### Collections

Create multiple images in one API request.

```ruby
bb.get_collection("collection uid")
bb.list_collections(:page => 3)
bb.create_collection("template set uid",
  :synchronous => true,
  :modifications => [
    {
      :name => "headline",
      :text => "Hello World!"
    }
  ]
) 
#collection options: modifications, webhook_url, metadata, transparent, synchronous
```

### Animated Gifs

Create a slideshow style gif

```ruby
bb.get_animated_gif("gif uid")
bb.list_animated_gifs(:page => 3)
bb.create_animated_gif("template uid",
  :frames => [
    [ #frame 1 starts here
      {
        :name => "layer1",
        :text => "This is my text"
      },
      {
        :name => "photo",
        :image_url => "https://www.pathtomyphoto.com/1.jpg"
      }
    ],
    [ #frame 2 starts here
      {
        :name => "layer1",
        :text => "This is my follow up text"
      },
      {
        :name => "photo",
        :image_url => "https://www.pathtomyphoto.com/2.jpg"
      }
    ]
  ]
) 
#animated gif options: frames, frame_durations, input_media_url, fps, loop, webhook_url, metadata
```

### Movies

Assemble video clips or still images into a single movie with transitions

```ruby
bb.get_movie("movie uid")
bb.list_movies(:page => 3)
bb.create_movie(:width => 800, :height => 800, :transition => "pixelize", :inputs => [
  {
    :asset_url => "https://images.unsplash.com/photo-1635910160061-4b688344bd20?w=500&q=60"
  },
  {
    :asset_url => "https://i.imgur.com/fH7a5dO.png"
  }
])
#movie options: width, height, transition, inputs, webhook_url, metadata
```

### Screenshots

Take screenshots of websites.

```ruby
bb.get_screenshot("screenshot uid")
bb.list_screenshots(:page => 3)
bb.create_screenshot("https://www.bannerbear.com/",
  :synchronous => true,
  :width => 1000
) 
#screenshot options: width, height, mobile, webhook_url, synchronous
```

### Templates

```ruby
bb.get_template("template uid")
bb.update_template("template uid", :name => "New Template Name", :tags => ["portrait", "instagram"])
bb.list_templates(:page => 2, :tag => "portrait")
```

### Template Sets

```ruby
bb.get_template_set("template set uid")
bb.list_template_sets(:page => 2)
```

### Video Templates

```ruby
bb.get_video_template("video template uid")
bb.list_video_templates(:page => 2)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yongfook/bannerbear-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yongfook/bannerbear-ruby/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bannerbear project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yongfook/bannerbear-ruby/blob/master/CODE_OF_CONDUCT.md).
