## [2.16.1](https://github.com/le4ker/nvmegachad/compare/v2.16.0...v2.16.1) (2026-09-29)

### 🐛 Bug Fixes

* **lint:** resolve nested Python environments ([668474d](https://github.com/le4ker/nvmegachad/commit/668474ddd58ecd6edfa02b1fc9f049ccfce6845e))
* **Makefile:** remove linux and windows support ([babb489](https://github.com/le4ker/nvmegachad/commit/babb489580c24fb347f7ead78875f808f79a7c65))
* **pyright:** enable workspace diagnostics ([81f4a3b](https://github.com/le4ker/nvmegachad/commit/81f4a3b60f81b060d0ae18c01bd1a627b6957535))
* **python:** use project environment for Pyright and Pylint ([ef93e0c](https://github.com/le4ker/nvmegachad/commit/ef93e0ce4d1dc903632a1de471db6b9b94343917))
* **treesitter:** use master compatible branch ([6263a2e](https://github.com/le4ker/nvmegachad/commit/6263a2ec33e33a791105d4cb47ec98b8cb75af77))

### 📚 Documentation

* update README.md ([3650ba4](https://github.com/le4ker/nvmegachad/commit/3650ba4584a68fddb3029e95392791c85e5346d8))

### 🏠 Chores

* add AGENTS.md ([4e32714](https://github.com/le4ker/nvmegachad/commit/4e32714b09f04bffedf98935da16ca95d232b33b))
* **mappings:** cleanup mappings ([123b9fb](https://github.com/le4ker/nvmegachad/commit/123b9fbd33cf8dc4ae8020202fc9f08457af2f8a))
* merge branch 'develop' ([bce2180](https://github.com/le4ker/nvmegachad/commit/bce2180c37a72729eecdfcb98a1d1a78e68c850e))
* remove unused code ([3d94eb9](https://github.com/le4ker/nvmegachad/commit/3d94eb9ee5156223a0b582ebead8429ff42f72f2))
* update AGENTS.md and CLAUDE.md ([918b0ab](https://github.com/le4ker/nvmegachad/commit/918b0ab8012a4c897230ead424563e800e379ce5))
* update comment ([b089aff](https://github.com/le4ker/nvmegachad/commit/b089aff2fe1f9dc109f67cac1f04066f56a3fdbb))

## [2.16.0](https://github.com/le4ker/nvmegachad/compare/v2.15.0...v2.16.0) (2026-09-28)

### ✨ Features

* **codecompanion:** authenticate via Pro OAuth token from macOS Keychain ([764ca0b](https://github.com/le4ker/nvmegachad/commit/764ca0bb8fc3fe64e2b0734d1170fc4d8470fc1a))
* **codecompanion:** prefer ANTHROPIC_API_KEY over Keychain OAuth token ([2032d9f](https://github.com/le4ker/nvmegachad/commit/2032d9fcfe020461f921e0203d791828028e06d3))
* **completion:** configure native LSP completion UI ([97a79f1](https://github.com/le4ker/nvmegachad/commit/97a79f18a89a77a0495f26402a311d3114bd5de9))
* **lsp:** add Scala support via nvim-metals and fix lua/lsp config loading ([f444c69](https://github.com/le4ker/nvmegachad/commit/f444c699731c9de66b1a452b0a21c81857c6975f))
* mapping for LSP completion ([cb73326](https://github.com/le4ker/nvmegachad/commit/cb733268230fcd139dda2e1cd3fc13a94373c0c5))
* **mappings:** add toggle to zoom CodeCompanion chat window ([777a440](https://github.com/le4ker/nvmegachad/commit/777a440854ec518b59ae4d4bb3d58772b0c3c4bf))

### 🐛 Bug Fixes

* **blink:** switch keymap preset from super-tab to manual bindings ([fcda26a](https://github.com/le4ker/nvmegachad/commit/fcda26a54965fceba198c8a81d987b07ae8e252b))
* **codecompanion:** remove inline adapter — not supported for non-HTTP adapters ([67c37d3](https://github.com/le4ker/nvmegachad/commit/67c37d36cf8863f4dac075c57c7f24de77ae8ce4))
* **lsp:** shellescape poetry_root in system() calls ([5bcee47](https://github.com/le4ker/nvmegachad/commit/5bcee478e5ce2941152a65c95d97de6a8ded0036))
* **mappings:** remove stale inline assist keybinding ([89879de](https://github.com/le4ker/nvmegachad/commit/89879deb9cce52783a8613961448618f39acc097))
* **nvim:** switch to blink.cmp for LSP autotrigger ([e17059e](https://github.com/le4ker/nvmegachad/commit/e17059e7e6dd6102e4b767f83591e4090bd2722d))
* **treesitter:** enable highlight module for syntax highlighting ([1a6e348](https://github.com/le4ker/nvmegachad/commit/1a6e3484210b3020b1627be24a1817312c6bf142))
* **treesitter:** switch to main branch for Neovim 0.12.2 compatibility ([50da03c](https://github.com/le4ker/nvmegachad/commit/50da03cdb0e05a00dbae7ee287dc1a2e55764516))

### 🔧 Refactoring

* **lsp:** move per-server configs from lua/lsp/ to lsp/ ([1ad0828](https://github.com/le4ker/nvmegachad/commit/1ad0828765494e6ab3ad8d151e0221cba3e7d65a))

### 📚 Documentation

* update playground/README.md ([17d2865](https://github.com/le4ker/nvmegachad/commit/17d286516287fc9b64c98481a330c1f63f86943b))

### 🏠 Chores

* merge branch 'develop' ([98625de](https://github.com/le4ker/nvmegachad/commit/98625de3c42057650144ff39964a66450a1099a9))
* **plugins:** update lazy-lock.json ([fe4efa6](https://github.com/le4ker/nvmegachad/commit/fe4efa6417e7d3c5e3866bd9b90d8cf7731712da))
* **plugins:** update lazy-lock.json ([3a79729](https://github.com/le4ker/nvmegachad/commit/3a7972911bf9805b1752c0ca6426d71a5d841709))
* **plugins:** update lazy-lock.json ([6131a67](https://github.com/le4ker/nvmegachad/commit/6131a675cfb6074f1e5260574ab4d57d2be13dcd))
* **plugins:** update lazy-lock.json ([a706694](https://github.com/le4ker/nvmegachad/commit/a706694dfacfd83a67c92048b33c1d4509290384))
* **plugins:** update lazy-lock.json ([d923c4c](https://github.com/le4ker/nvmegachad/commit/d923c4cf8da15075474aba9a5da165b51b1c5a51))
* **plugins:** update lazy-lock.json ([1672ff4](https://github.com/le4ker/nvmegachad/commit/1672ff4524268b69b77ce6f88a0e439ec4586569))
* **plugins:** update lazy-lock.json ([c0c3093](https://github.com/le4ker/nvmegachad/commit/c0c309311387db9ca2e494787b6972fc8c838212))
* **plugins:** update lazy-lock.json ([f4487e9](https://github.com/le4ker/nvmegachad/commit/f4487e9aaf201e3575ea754659ef9c5242388818))
* **plugins:** update lazy-lock.json ([1ca9170](https://github.com/le4ker/nvmegachad/commit/1ca917003c3207de2205b4273888b7660880dffb))

## [2.15.0](https://github.com/le4ker/NvMegaChad/compare/v2.14.0...v2.15.0) (2026-05-17)

### ✨ Features

* **lsp:** add jsonls for JSON language support ([99e8c6c](https://github.com/le4ker/NvMegaChad/commit/99e8c6c0da00a33e11a5cd7d2e97132c0b54aad9))
* **make:** add checkmake linter and eager-load Mason ([4481f7b](https://github.com/le4ker/NvMegaChad/commit/4481f7bec61109eee4918aa10ca78f62bbac7ee9))
* **make:** add checkmake linter and eager-load Mason ([2902546](https://github.com/le4ker/NvMegaChad/commit/2902546767955a0269798e58604be251a53aa2c5))

### 🐛 Bug Fixes

* **codecompanion:** switch inline adapter to claude_code ([99828c2](https://github.com/le4ker/NvMegaChad/commit/99828c2f4e21c0a1619d282ec107b51427c0819a))
* **codecompanion:** update claude-agent-acp package name ([d70a4e7](https://github.com/le4ker/NvMegaChad/commit/d70a4e7e4b74e99809888addfee15108e74b19fd))
* **dap:** ensure dap-ui loads with any DAP command ([c54b579](https://github.com/le4ker/NvMegaChad/commit/c54b57991aaf97649f085da28be8901676d9c5c9))
* **lint:** check executable for Poetry venv pylint path ([f85cff5](https://github.com/le4ker/NvMegaChad/commit/f85cff5f1e6a611d4b42c8d1f0f418f591fa2f71))
* **lint:** verify pylint binary exists before using venv path ([b3f50f3](https://github.com/le4ker/NvMegaChad/commit/b3f50f3bad3e7c13ad394e32f0a97fed50259abf))
* **lsp:** remove hardcoded extraPaths from pyright config ([2018daa](https://github.com/le4ker/NvMegaChad/commit/2018daa672731f9bf97aa4ebcf4b40f2f75e811f))
* **lsp:** remove tflint from LSP servers list ([74d0d14](https://github.com/le4ker/NvMegaChad/commit/74d0d14a65c4c623a57ddcff60141b17ecd9996e))
* **makefile:** remove --force and sudo from npm install for claude-agent-acp ([dba6e21](https://github.com/le4ker/NvMegaChad/commit/dba6e21e7b55e845539999e8cfa890c814963c29))
* **make:** use correct npm package for claude-code-acp install ([75b6838](https://github.com/le4ker/NvMegaChad/commit/75b68384a013994d074f37a74430a5f3efcdf2cf))
* **markdown-preview:** use correct executable check for npx ([3aebc81](https://github.com/le4ker/NvMegaChad/commit/3aebc815602beec7c5f01b825086e6de4fff0cc7))
* **mason:** notify on failed package installation ([3db17bb](https://github.com/le4ker/NvMegaChad/commit/3db17bb34915d1d0fe61b9877f847b1cc0c2ee9e))
* **mason:** open Mason UI after async registry refresh completes ([cbd2d3c](https://github.com/le4ker/NvMegaChad/commit/cbd2d3c8d66788c88a18544a0554d8417a659a45))
* **treesitter:** add nvim-treesitter runtime/ to rtp for highlight queries ([48baad7](https://github.com/le4ker/NvMegaChad/commit/48baad76293d46631c14c0da3f5ee8b7ef3e8d76))
* **treesitter:** remove invalid jsonc parser from ensure_installed ([a0486c5](https://github.com/le4ker/NvMegaChad/commit/a0486c505ac995b9698be412e12530eaa76b1a7c))

### 🔧 Refactoring

* **conform:** remove unnecessary options intermediate table ([830fbfc](https://github.com/le4ker/NvMegaChad/commit/830fbfcbebc38443f912bffdce9a078cea9264bf))
* **dap:** remove redundant lazy = true ([a5c4c68](https://github.com/le4ker/NvMegaChad/commit/a5c4c68fbf635679b21978f887e68ae90b3b4316))
* **lsp:** remove work-specific Panther schemas from yamlls ([821c13a](https://github.com/le4ker/NvMegaChad/commit/821c13a943ecdcf8ad1471aadc387fb93a0c1585))
* **plugins:** apply two-file pattern to all plugin specs ([e8d6263](https://github.com/le4ker/NvMegaChad/commit/e8d6263dfc39bf3ef0a86f307e9f4341fcb3d9a6))

### 📚 Documentation

* **claude:** expand CLAUDE.md with missing rules and design decisions ([fd14472](https://github.com/le4ker/NvMegaChad/commit/fd144721784442e0372a47e0052b5d4ccc840806))
* **lint:** clarify pylint cmd comment to reflect all fallback cases ([a30d7ee](https://github.com/le4ker/NvMegaChad/commit/a30d7eeb841e743c401beaf16b568d9f4110dcd0))

### 🏠 Chores

* merge branch 'develop' ([3121f03](https://github.com/le4ker/NvMegaChad/commit/3121f03aee498b9911f1335ca76e2eef16f5ab7b))
* **plugins:** update lazy-lock.json ([821041c](https://github.com/le4ker/NvMegaChad/commit/821041ccfa01da1a80088420a63d1c48f733bbb0))
* **plugins:** update lazy-lock.json ([7fef93f](https://github.com/le4ker/NvMegaChad/commit/7fef93f3a573bbdba3b98ad0d1837abeffc59914))
* **plugins:** update lazy-lock.json ([9ff25ea](https://github.com/le4ker/NvMegaChad/commit/9ff25eaca854437b6f0345c90da5d94f250c3feb))
* **plugins:** update lazy-lock.json ([ec5d884](https://github.com/le4ker/NvMegaChad/commit/ec5d884ea08373c6c14cdd07e2e729018ea24627))
* **plugins:** update lazy-lock.json ([422257a](https://github.com/le4ker/NvMegaChad/commit/422257af825dbbc0d3c5f1c8f62ae76ad2b61094))
* **plugins:** update lazy-lock.json ([b37feb1](https://github.com/le4ker/NvMegaChad/commit/b37feb16cb5ccde7ee4ac7f5fe1afda545863314))
* **plugins:** update lazy-lock.json ([3dc700f](https://github.com/le4ker/NvMegaChad/commit/3dc700f6f4afb0d72ccd444c1ca32743136e71c9))
* **plugins:** update lazy-lock.json plugin versions ([be0f6be](https://github.com/le4ker/NvMegaChad/commit/be0f6be1826be1f66b8b28b01f83f568bc07db96))

## [2.14.0](https://github.com/le4ker/NvMegaChad/compare/v2.13.0...v2.14.0) (2026-03-01)

### ✨ Features

* add Claude Code via ACP as CodeCompanion AI backend ([b288568](https://github.com/le4ker/NvMegaChad/commit/b28856884ad81e5d1af1194f67ddb81b44af8e4f))
* **conform:** add Makefile formatting support via bake ([d1f471e](https://github.com/le4ker/NvMegaChad/commit/d1f471e260541436c18bf735bbd3ee337e79c1d6))
* update CodeCompanion models to claude-opus-4-6 and claude-sonnet-4-5 ([0de2357](https://github.com/le4ker/NvMegaChad/commit/0de2357bb06f68ea7d6b699737980e0efa9877cc))

### 🔧 Refactoring

* simplify codecompanion default_tools to use agent only ([bee55a7](https://github.com/le4ker/NvMegaChad/commit/bee55a77ed072c7a7c84084e3afe91deb9ae3473))

### 🏠 Chores

* add Claude Code project instructions and local settings ([c40b493](https://github.com/le4ker/NvMegaChad/commit/c40b49305d21c5f9ed4b31a0355436be27d9ee1c))
* add comments to .gitignore ([4d8c458](https://github.com/le4ker/NvMegaChad/commit/4d8c458a20a65d07896d5508c8d4c9092c1fa7ba))
* gitignore .claude/settings.local.json, untrack it ([6ce3ac8](https://github.com/le4ker/NvMegaChad/commit/6ce3ac8f7fdea43bb6ccbd31d27eeae9434f862e))
* Merge branch 'develop' ([e349201](https://github.com/le4ker/NvMegaChad/commit/e3492018c888239caa81d1d086f0c139ff52e76c))
* update plugin versions in lazy-lock.json ([a713864](https://github.com/le4ker/NvMegaChad/commit/a7138648b9c2a56a481480e1585fe47aed0126fa))
* update plugin versions in lazy-lock.json ([962d8fb](https://github.com/le4ker/NvMegaChad/commit/962d8fbeec2f1764f95ef480b2c24f1ad4fcfdf4))
* update plugin versions in lazy-lock.json ([fe0a172](https://github.com/le4ker/NvMegaChad/commit/fe0a172a543de259d9a7df9f6d72f99290a4c5d7))

## [2.13.0](https://github.com/le4ker/NvMegaChad/compare/v2.12.0...v2.13.0) (2026-01-24)

### ✨ Features

* **mappings:** add notification when updating Mason packages ([c6a7a64](https://github.com/le4ker/NvMegaChad/commit/c6a7a646d6fad3afeaae636364d5dc012a3672b9))
* **options:** enable persistent undo with undofile ([2641958](https://github.com/le4ker/NvMegaChad/commit/26419582fabc81812c591c73ef8dd1b6da0a8cb6))

### 🐛 Bug Fixes

* disable insertReplaceSupport for gopls completion ([f09e62b](https://github.com/le4ker/NvMegaChad/commit/f09e62bde8cc1af0a42d973406c6ccb2907911a2))

### 🔧 Refactoring

* remove comment ([e0deb20](https://github.com/le4ker/NvMegaChad/commit/e0deb20f15ae038e2c8ce25291f030be6cbf054a))
* remove comment ([6fadbf8](https://github.com/le4ker/NvMegaChad/commit/6fadbf8e34335537ff1693e8751e904e0649b07c))
* remove lspcofnig code that is not needed in Neovim 0.11+ ([98a544b](https://github.com/le4ker/NvMegaChad/commit/98a544bdd05812f7473821191a9fcc544e581303))

### 📚 Documentation

* add badges ([1ce1f8f](https://github.com/le4ker/NvMegaChad/commit/1ce1f8f0b114f11db0c43bb00628b10b6a811de2))
* update README image ([03e1afd](https://github.com/le4ker/NvMegaChad/commit/03e1afd09127e3aea93eff1836a838943e93bc35))

### 🏠 Chores

* merge develop into main ([d4ecd87](https://github.com/le4ker/NvMegaChad/commit/d4ecd87cda4b3ad22fd1682ba0f780329bcae2f8))
* update plugin versions in lazy-lock.json ([7a4792f](https://github.com/le4ker/NvMegaChad/commit/7a4792f7a2bf30a8cb8c8d97f0dde8979b4f9d7c))
* update plugin versions in lazy-lock.json ([f2cbf8f](https://github.com/le4ker/NvMegaChad/commit/f2cbf8f6b968f5472daba0f745c21658d922d556))
* update plugin versions in lazy-lock.json ([5976f4f](https://github.com/le4ker/NvMegaChad/commit/5976f4fb4abc6adb801855a66a943b8144043f64))

## [2.12.0](https://github.com/le4ker/NvMegaChad/compare/v2.11.0...v2.12.0) (2026-01-04)

### ✨ Features

* add CodeCompanion inline assist with Claude Sonnet ([5b6d91c](https://github.com/le4ker/NvMegaChad/commit/5b6d91c16e349439a874173c109bf8d35523b08c))
* add mappingto close terminal in normal mode ([b701735](https://github.com/le4ker/NvMegaChad/commit/b70173564204294ce1d4acf79ecdd7e62c2e28aa))
* add nginx and requirements treesitter parsers ([f80156e](https://github.com/le4ker/NvMegaChad/commit/f80156eca389ebe2f2124f033c2b1c9461d1bf6c))
* add toggle for LSP inlay hints (<leader>ti) ([bd9b9dc](https://github.com/le4ker/NvMegaChad/commit/bd9b9dc373abb15d10bfb576cbd42b89612cdede))
* close telescope on <Esc><Esc> ([5238cb8](https://github.com/le4ker/NvMegaChad/commit/5238cb85cd517c17247c890003bf32d8ebd07e12))
* disable approval prompts for read-only CodeCompanion tools ([81a6f95](https://github.com/le4ker/NvMegaChad/commit/81a6f9558c85393c8805ba05316447ee7f61738d))
* enable inlay hints ([4bae044](https://github.com/le4ker/NvMegaChad/commit/4bae044a3eee5a33a2aae1b981a2fd4e642cbc0e))

### 🐛 Bug Fixes

* remove web_search tool ([bc0bdd7](https://github.com/le4ker/NvMegaChad/commit/bc0bdd7a2cfce16cb2c22731c7a59e33a35b1486))
* use native LSP completion with proper Tab/Enter keymaps ([1127028](https://github.com/le4ker/NvMegaChad/commit/1127028918f8a36d47ef4c6f5c5d06ed7a5b0394))

### 🔧 Refactoring

* migrate from nvim-cmp to Nneovim's 0.11 native completion API ([9a4ffaa](https://github.com/le4ker/NvMegaChad/commit/9a4ffaab9a309d5d9a5b96a998844e1b1c59690d))
* reorganize CodeCompanion config structure ([2e5535c](https://github.com/le4ker/NvMegaChad/commit/2e5535c900fbdcfcd64520db8439e39cf648dbd7))
* update mapping descriptions ([f53a6d6](https://github.com/le4ker/NvMegaChad/commit/f53a6d60b1eb7e11198ca34d6fe837fbb5077555))

### 📚 Documentation

* remove Release process from README ([83c661f](https://github.com/le4ker/NvMegaChad/commit/83c661ff0e0b5bc583dd02b06a448cbf76db04ef))
* update README.md ([df2bffa](https://github.com/le4ker/NvMegaChad/commit/df2bffa56671bc039a5c89497a6c386886ba0ffa))

### 🏠 Chores

* **license:** change license from GPL-3.0 to Apache-2.0 ([2d8bffd](https://github.com/le4ker/NvMegaChad/commit/2d8bffd37d7a562a7df5481c2e1e5fefc4a98407))
* update plugin versions in lazy-lock.json ([af4df60](https://github.com/le4ker/NvMegaChad/commit/af4df600851b7469b18696b756d49fe5ea8b9d46))

## [2.11.0](https://github.com/le4ker/NvMegaChad/compare/v2.10.0...v2.11.0) (2026-01-03)

### ✨ Features

* add CodeCompanion keymaps for actions and chat toggle ([3a95395](https://github.com/le4ker/NvMegaChad/commit/3a9539545c849f909fa566ae8975bd52535728f1))
* enable more tools for CodeCompanion ([35a7b26](https://github.com/le4ker/NvMegaChad/commit/35a7b261f21e8c4d86e03023be27d37bbf4ff406))
* set cheatsheet theme to simple ([54de0d4](https://github.com/le4ker/NvMegaChad/commit/54de0d4c39aa1b25edc5c67ec22eda6b7ec1be97))
* update statusline theme ([92a09b7](https://github.com/le4ker/NvMegaChad/commit/92a09b77a9f00fc59b97e5d078cf16162229998e))

### 🐛 Bug Fixes

* make trail more visible ([b9a4176](https://github.com/le4ker/NvMegaChad/commit/b9a4176a1853c88752b13ea6d7d856b64d15f4a2))
* remove space from mapping and make <leader>fa silent ([98a6d56](https://github.com/le4ker/NvMegaChad/commit/98a6d56fd9d4475ce6588ebab6f18aa7cf7705e6))
* restore live grep mapping ([6cf389a](https://github.com/le4ker/NvMegaChad/commit/6cf389ae0fc4b9dfdd02c540851324fe2dfae0c3))
* run 10 concurrent Mason installations ([8993e4e](https://github.com/le4ker/NvMegaChad/commit/8993e4ea649ea76553f4176fa97be96567e16494))
* update installed Mason packages on <leader>mu ([6f84460](https://github.com/le4ker/NvMegaChad/commit/6f84460d7eaf59c279bb5da995c3b36a6c748eff))

### 🔧 Refactoring

* copy whole file on <leader>y ([ec40ecd](https://github.com/le4ker/NvMegaChad/commit/ec40ecd8ac4665fbf07e08dba3a45b69a431c2d3))
* move CodeCompanionChat mapping to mappings.lua ([2bada9c](https://github.com/le4ker/NvMegaChad/commit/2bada9cf9db8a6f2866c3f8190651f1fedd5f74a))
* re-organize Cheatsheet ([b6142d3](https://github.com/le4ker/NvMegaChad/commit/b6142d3be5aad614a7cbe7c95196c032a10268ba))
* replace comment plugin with native Neovim API ([a329242](https://github.com/le4ker/NvMegaChad/commit/a32924289bdfd597d600b969db9f3e9a1846ccca))
* update mapping descriptions ([5631f23](https://github.com/le4ker/NvMegaChad/commit/5631f2362dad959e1618daaabc399b7302d35840))
* update mapping descriptions ([8df83dd](https://github.com/le4ker/NvMegaChad/commit/8df83dd88dacf9fa0ddf82890fa26f9758d812a8))

### 📚 Documentation

* update images ([979d0c9](https://github.com/le4ker/NvMegaChad/commit/979d0c9fcc6eb81d2380ebc15bf5efa2bcff3a7b))
* update README images ([8c1c73b](https://github.com/le4ker/NvMegaChad/commit/8c1c73b9a4796c3e3b2136f38cc0e77167730caa))

### 🏠 Chores

* update plugin versions in lazy-lock.json ([0e4add4](https://github.com/le4ker/NvMegaChad/commit/0e4add4e3ac1211757f9f489e99905d93e44f4ba))

## [2.10.0](https://github.com/le4ker/NvMegaChad/compare/v2.9.0...v2.10.0) (2025-12-26)

### ✨ Features

* add lua_ls to LSP servers list ([a8204a7](https://github.com/le4ker/NvMegaChad/commit/a8204a7458556e78a77d26f4e78a9002a1a2f84f))
* **dap:** add mapping to toggle DAP UI ([697b6be](https://github.com/le4ker/NvMegaChad/commit/697b6be37ad9bc14c67da6e9d9d1563be0f704cd))
* **lsp:** add gD mapping for go to declaration ([8a3abab](https://github.com/le4ker/NvMegaChad/commit/8a3abab881c8d1a3e778eea7f331fd8d9a93adc2))
* use double-ESC to close terminal, single ESC exits terminal mode ([00b6870](https://github.com/le4ker/NvMegaChad/commit/00b6870f4d795b24d0368e46a96136a87f5d5500))

### 🐛 Bug Fixes

* add timeout to conform format and fix indentation ([93eddd2](https://github.com/le4ker/NvMegaChad/commit/93eddd2dfd490cca0c672fa6fc0ccc8db80c215b))
* **lsp:** add on_attach and capabilities to all servers ([d0d07be](https://github.com/le4ker/NvMegaChad/commit/d0d07beb59ab546029bd252d2e44f56b21acf3a5))
* **lsp:** load custom server configs from lua/lsp directory ([9107b5c](https://github.com/le4ker/NvMegaChad/commit/9107b5c78c3599d274f4d211f14d9b684bfcffdf))
* refresh mason registry before installing packages ([f78ea3e](https://github.com/le4ker/NvMegaChad/commit/f78ea3e3c7e3193f06294782b1169f2d074250b5))
* remove conflicting terminal <ESC> mapping ([56ef7ab](https://github.com/le4ker/NvMegaChad/commit/56ef7abb5c9643e118af9fcd1bdd95504c759778))
* remove duplicate lspconfig defaults call ([4633359](https://github.com/le4ker/NvMegaChad/commit/4633359765a22f06a19a564f4573cc28c411f7a7))
* set formatter timeout ([f06601f](https://github.com/le4ker/NvMegaChad/commit/f06601f743001c3d5b3121c463618bcdd27033ce))

### 🔧 Refactoring

* remove redundant on_attach and capabilities from lspconfig ([2def766](https://github.com/le4ker/NvMegaChad/commit/2def766678dfb392170734bf0534c48c7740dcf0))
* use conform's built-in format_on_save option ([e86514b](https://github.com/le4ker/NvMegaChad/commit/e86514b05a79934419bbee6c33d0b7c557589cfa))

### 🏠 Chores

* **mappings:** standardize command spacing ([7478ad8](https://github.com/le4ker/NvMegaChad/commit/7478ad8d9fcb1bdf45e6f136ca1aad250f806130))
* remove obsolete LuaSnip unmappings ([a747c34](https://github.com/le4ker/NvMegaChad/commit/a747c34a37a43b02a1c62ebaaa1365072dd9dc8c))
* update plugin versions in lazy-lock.json ([a436e5a](https://github.com/le4ker/NvMegaChad/commit/a436e5a5578761260428a8b242b440846c131b70))

## [2.9.0](https://github.com/le4ker/NvMegaChad/compare/v2.8.0...v2.9.0) (2025-12-26)

### ✨ Features

* **treesitter:** add htmldjango parser support ([69c8459](https://github.com/le4ker/NvMegaChad/commit/69c8459666c9a9bf34bd14900d61644bc45f9f2f))

### 🔧 Refactoring

* **lsp:** simplify lspconfig and move server configs to separate files ([6388da2](https://github.com/le4ker/NvMegaChad/commit/6388da245794cb0d467577f21a9fd7b466725a6e))
* **lsp:** simplify lspconfig and move server configs to separate files ([0322294](https://github.com/le4ker/NvMegaChad/commit/03222947fbe19d6918cf96337b8ec67d83bf3b11))

### 📚 Documentation

* update README.md ([0f48a38](https://github.com/le4ker/NvMegaChad/commit/0f48a38fbcdd8be498ddc4ae62561e26a95ca1da))

### 🏠 Chores

* add semantic-release automation ([14f20d0](https://github.com/le4ker/NvMegaChad/commit/14f20d0b1cc732e012783704d2100236cc65d28d))
* **release:** 2.9.0 ([9636178](https://github.com/le4ker/NvMegaChad/commit/9636178132216082a690cf5191c5ed80fb8288ea))
* **release:** migrate to YAML config and customize release sect ([bbfcbfc](https://github.com/le4ker/NvMegaChad/commit/bbfcbfcfffa99385cb3f50ae878865700f2e33a0))
* trigger release workflow ([98372c2](https://github.com/le4ker/NvMegaChad/commit/98372c26a08a65d4d745ae3846ec78fb71b48767))

## [2.9.0](https://github.com/le4ker/NvMegaChad/compare/v2.8.0...v2.9.0) (2025-12-26)

### ✨ Features

* **treesitter:** add htmldjango parser support ([69c8459](https://github.com/le4ker/NvMegaChad/commit/69c8459666c9a9bf34bd14900d61644bc45f9f2f))

### 🔧 Refactoring

* **lsp:** simplify lspconfig and move server configs to separate files ([6388da2](https://github.com/le4ker/NvMegaChad/commit/6388da245794cb0d467577f21a9fd7b466725a6e))
* **lsp:** simplify lspconfig and move server configs to separate files ([0322294](https://github.com/le4ker/NvMegaChad/commit/03222947fbe19d6918cf96337b8ec67d83bf3b11))

### 📚 Documentation

* update README.md ([0f48a38](https://github.com/le4ker/NvMegaChad/commit/0f48a38fbcdd8be498ddc4ae62561e26a95ca1da))

### 🏠 Chores

* add semantic-release automation ([14f20d0](https://github.com/le4ker/NvMegaChad/commit/14f20d0b1cc732e012783704d2100236cc65d28d))
* **release:** migrate to YAML config and customize release sect ([bbfcbfc](https://github.com/le4ker/NvMegaChad/commit/bbfcbfcfffa99385cb3f50ae878865700f2e33a0))
