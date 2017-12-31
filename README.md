# DashVis

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=shields)](http://makeapullrequest.com)

DashVis is an open-source Dashboard built with Rails for all users in general. DashVis can be used to organize your resources via `Tables` and `Collections`.

 ![image](https://raw.githubusercontent.com/athityakumar/DashVis/master/app/assets/images/dv-fb.png?token=AQUQRPr9-DOdAG_taggB3AIFXLzUfEHaks5aUSUswA%3D%3D)

# Table of contents

- [What is DashVis?](#what-is-dashvis)
- [Is DashVis like Google Sheets?](#is-dashvis-like-google-sheets)
- [How to use DashVis?](#how-to-use-dashvis)
- [Pro ways to use DashVis](#pro-ways-to-use-dashvis)
- [Why is it named DashVis anyway?](#why-is-it-named-dashvis)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

# What is DashVis?

[(Back to top)](#table-of-contents)

Having surfed on the internet for so long, I came to see multiple web applications that handle a single (specific) type of tabular data - Passwords, Wallets, Bookmarks, Notepads, To-Dos, Playlist and what not! Rather, why not have a single web application that provides the user with the power to manipulate tabular data as they wish?

This lead to inception of DashVis, and is exactly what DashVis stands for - to provide users with power of managing their data at a single place.

# Is DashVis like Googe Sheets?

[(Back to top)](#table-of-contents)

Yes and No.

DashVis tries to mix the traditional CRUD functionality like Google Sheets along with a Dashboard interface (like the stand-alone applications). With a tabular interface, searching and organizing resources is easier.

Though, DashVis is at it's infancy right now. There are lots of potential features that can still be incorporated into DashVis. Have a look at the [Roadmap](#roadmap) or [Issue tracker]() for more details.

# How to use DashVis?

[(Back to top)](#table-of-contents)

1. Login with your social media accout (Google, Facebook, LinkedIn or GitHub)
2. You'll see that there are 2 segregations : `Tables` and `Collections`.
    - `Tables` : These are your individual tables, such as `Books`, `YouTubers`, `Wallet`, `Policies`.
    - `Collections` : These are your tags, such as `Entertainment`, `Finance`, `2018`, etc.
    - **NOTE** : A collection can contain multiple tables. Similarly, a table can also belong to multiple collections.
3. Create new `Tables`, new `Collections` and add your specific tables to each collection (as you prefer).
4. Search for your `Tables` and `Collections` in the dashboard.
5. Find DashVis useful? Share it with your friends.

# Pro ways to use DashVis

[(Back to top)](#table-of-contents)

Flavouring the tabular data with a little bit of HTML tags can add a zing to your viewing experience. For example,

- Add Hyperink to open in new tab : `<a href="https://enter/the/url.here" target="_blank">Link text</a>`
- Add Image : `<img src="https://path/to/image.jpg" width="100" height="100">`

# Why is it named DashVis?

[(Back to top)](#table-of-contents)

- `Dash` is short for Dashboard.
- `Vis` is short for Visualization. 
    - Currently, only tabular visualization is supported. However, support for charts visualization is coming soon.

- `DashVis` remotely spells and sounds like Jarvis.

# Roadmap

[(Back to top)](#table-of-contents)

- [x] Tables : Create, Update and Delete functionalities for Rows and Columns.
- [x] Collections : Create, Update and Delete functionalities.
- [ ] Custom Table Template : Create, Update and Delete functionalities.
- [ ] Ability to share Tables / Collections, with Public / specific user, with specific access level (read, write or admin).
- [ ] Charts : Create, Update and Delete functionalities.
- [ ] Optimize application to reload only specific parts of website with AJAX.
- [ ] Support scrapers to feed real-time data into a specific Table.
- [ ] Table-wise timelines

# Contributing

[(Back to top)](#table-of-contents)

Your contributions are always welcome! Please have a look at the [contribution guidelines](CONTRIBUTING.md) first. :tada:

# License

[(Back to top)](#table-of-contents)

The MIT License (MIT) 2018 - [Athitya Kumar](https://github.com/athityakumar/). Please have a look at the [LICENSE.md](LICENSE.md) for more details.
