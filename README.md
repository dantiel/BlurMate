# BlurMate = TM2 + Alpha &rarr; Vibrance

![BlurMate](https://github.com/dantiel/blurmate/raw/master/screenshot.png)

A very quick and dirty TextMate 2 plugin that simply blurs the window background using the new vibrance modes. Useful if you have a theme with a transparent background, where otherwise it can make things pretty unreadable sometimes. I recommend editing the theme you wish use and set a _very_ transparent background as the effect wont be visible otherwise. See the [themes section](#Themes) as well.

Forked from [BlurMate](https://github.com/cliffrowley/blurmate) for TM2, which was inspired by BlurMate for TM1, for which the source code was never released.  I hijacked the name because, well, because nothing’s without a cause.

## Installing

Simply grab the latest release and drop it in `~/Library/Application Support/TextMate/PlugIns` (create the folder if it doesn't exist already).  Double clicking to install doesn't work for some reason.  No biggie. 

## Configuring

The default vibrance mode is `dark`. Some of the modes I quickly implemented are more useful than others. You can change it using `defaults` like this:

`defaults write com.macromates.TextMate.preview BlurMateVibrance <ultra-dark|dark|medium-dark|medium|medium-light|light>`

## Themes

See this [collection of TextMate  themes][vibrance_themes_github] especially edited to be used with this plugin.

## Uninstalling

Just remove `BlurMate.tmplugin` from `~/Library/Application Support/TextMate/PlugIns`.

## Contributing

Pull requests are welcome.  Plagiarism welcome too.  It took me literally an hour to throw together, with a little code borrowed from iTerm2.  If you can make something better based on this then please feel free to do so and I'll happily use yours.


[vibrance_themes_github]: https://github.com/dantiel/TextMate-Vibrance-Themes "TextMate Vibrance Themes Repository"
