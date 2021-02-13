# You Don't Know Jack 2015 .jet file parser

You ever played a game of YDKJ with your child or parent and together you run into a question about "sex positions and neckties"?

Here's a YDKJ data file parser that extracts Episode content into a JSON file containing question and answer text for each episode to assist in identifying family unsafe/awkward content.

To be clear... [newer Jackbox games](https://jackboxgames.happyfox.com/kb/article/3-are-your-games-family-friendly-what-are-they-rated/) already have family filter, so let's just consider this a fun afternoon project. ;)

# Getting Started

* Execute the `YDKJ_parser.ps1` Powershell file from the `$\JackboxPartyPack1\games\YDKJ2015` folder. This will parse all episodes and save an `episodeConversion.json` file that can be parsed by apps or opened in a text editor like [VSCode](https://code.visualstudio.com/).

# Troubleshooting

* Script doesn't run. Error message is similar to `<File> cannot be loaded because the execution of scripts is disabled on this system.`
  * See: [About Execution Policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.1)