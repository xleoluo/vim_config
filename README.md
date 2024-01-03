# SimpleNvim - Elegance That Stands the Test of Time

Welcome to SimpleNvim! This is a pre-configured setup tailored for Neovim, designed to provide you with an elegant and efficient editing environment, making your coding journey more enjoyable and productive.

<h6 align="center">visual_studio_code theme</h6>

![image](https://github.com/askfiy/SimpleNvim/assets/81478335/4ee2eeff-cc50-44b0-9114-82219ce2b487)


<h6 align="center">killer-queen theme</h6>

![image](https://github.com/askfiy/SimpleNvim/assets/81478335/aae19a2b-4bf3-4c94-a858-368c1af0ce6b)

## Key Features

- **Simplicity in Configuration**: SimpleNvim is renowned for its minimalist design, enabling you to get started effortlessly without complex setups.
- **Empowered Extensions**: Packed with a curated selection of plugins and tools, it empowers you to unlock the full potential of Neovim.
- **Personalized Customization**: Unleash your creativity and personalize SimpleNvim to match your preferences, making the editor a canvas for your work of art.
- **Swift Navigation**: Equipped with intuitive shortcuts and navigation features, it allows seamless traversal through code, enhancing your coding efficiency.
- **Continuous Maintenance**: We keep up with the latest developments in Neovim to ensure that SimpleNvim remains up-to-date.

## Getting Started

> SimpleNvim is built on top of the latest preview version of Neovim, and you can use [bob](https://github.com/MordechaiHadad/bob) to install the preview version of Noevim

Follow these steps to start using SimpleNvim:

1. Install Neovim: If you haven't already, install Neovim according to your operating system.

2. Clone the Repository: Clone the SimpleNvim repository to your local machine using the following command:

```sh
$ git clone https://github.com/askfiy/SimpleNvim.git ~/.config
$ mv ~/.config/SimpleNvim ~/.config/nvim
```

3. When you open Neovim, it automatically downloads most of the dependencies.

## Structured configuration

SimpleNvim provides reasonable configurations, but you are still free to change them.

If you have some experience with Lua coding, I believe this is easy to solve.

```sh
conf/config.lua: User profile
conf/preference.lua: Neovim built-in item preference configuration

core/depends: Most of the dependencies are stored here
core/package: Contains all currently supported language packs for SimpleNvim

core/mapping.lua: Neovim basic key mapping
core/setting.lua: Provides some convenient APIs for configuration items that are used only internally

utils/API: Provides a variety of utility functions
```

## Contributions and Feedback

Feel free to raise suggestions, questions, or issues in the project's Issues section. We welcome contributions in all forms to make SimpleNvim even better.

## License

This project is licensed under the MPL-2.0 License.
