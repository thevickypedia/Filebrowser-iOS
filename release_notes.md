Release Notes
=============

v1.30.0 (08/13/2025)
--------------------
- [4371d81](https://github.com/thevickypedia/Filebrowser-iOS/commit/4371d81c871bace226f0e4856901cfc889235a0b) chore: Release ``v1.30.0``
- [724954e](https://github.com/thevickypedia/Filebrowser-iOS/commit/724954e50d21e0c251dffff4dd8d23065dc03f70) perf: Create a centralized url builder and remove double/inconsistent encoding
- [2e753ae](https://github.com/thevickypedia/Filebrowser-iOS/commit/2e753ae44f9b837c960fb26ede0a380ed01c993e) perf: Improved logging for server requests
- [ff3cb75](https://github.com/thevickypedia/Filebrowser-iOS/commit/ff3cb75ca7e4f2fa4727325366e2c72e7570280c) perf: Make server errors more explicit
- [3d34729](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d347295dfda365229620b407b08ccc72883a9b1) perf: Increase stability in file extension checkers
- [b20340b](https://github.com/thevickypedia/Filebrowser-iOS/commit/b20340b2a1a0e44adba9fa8fb86cf823a0dbdd38) style: Display file extension as type only when available
- [d02013a](https://github.com/thevickypedia/Filebrowser-iOS/commit/d02013a9f7093270eaa4d8fe1cac9606dc568a93) revert: Rollback fullscreen images for single tap gesture
- [5f0f6a1](https://github.com/thevickypedia/Filebrowser-iOS/commit/5f0f6a1c93a95af73d0c3e388ddc04a445bce103) feat: Allow full screen mode on images for single tap gesture
- [1e762c8](https://github.com/thevickypedia/Filebrowser-iOS/commit/1e762c8979ed04166a5b07e637f70d01f472d8a7) chore: Update release notes for v1.29.3

v1.29.3 (08/12/2025)
--------------------
- [03ae13c](https://github.com/thevickypedia/Filebrowser-iOS/commit/03ae13c98272d98001a1bd423efa92a8a7134422) chore: Release ``v1.29.3``
- [26601a8](https://github.com/thevickypedia/Filebrowser-iOS/commit/26601a8903dbcd75f3d311e76f12674204c042de) perf: Silently re-authenticate if JWT is invalid
- [a560a5f](https://github.com/thevickypedia/Filebrowser-iOS/commit/a560a5f63a8be4ba45339576f23fc03b7d955117) revert: Rollback keychain storage with primarykeys
- [f722a72](https://github.com/thevickypedia/Filebrowser-iOS/commit/f722a728ba3453a6f82f840eb0e68504ef535be9) feat: Store sessions in keychain with serverURL and username as primarykeys
- [89a165c](https://github.com/thevickypedia/Filebrowser-iOS/commit/89a165c6471e7a4e805f38f8f7b0f73cf3b127b2) refactor: Remove redundant function to fetch user account
- [6e73f5b](https://github.com/thevickypedia/Filebrowser-iOS/commit/6e73f5b0cca6ddad86a3a7e43b8bbce8813476d3) refactor: Handle auth errors more accurately
- [f6aa852](https://github.com/thevickypedia/Filebrowser-iOS/commit/f6aa852153fe9b6e417326c2c6b28e2a44aa4f21) refactor: Create a hand-shake with the server even when FaceID is still valid
- [9057d32](https://github.com/thevickypedia/Filebrowser-iOS/commit/9057d323a0e412d4a3ae9a7d4ea3b96d3fdfee90) chore: Update release notes for v1.29.2

v1.29.2 (08/11/2025)
--------------------
- [5d9e715](https://github.com/thevickypedia/Filebrowser-iOS/commit/5d9e715d79616a4fc3e291a1c659ee641d35593b) chore: Release ``v1.29.2``
- [ce1fdb3](https://github.com/thevickypedia/Filebrowser-iOS/commit/ce1fdb32a9ff76aa5375eaff333dcea2b9ee3437) refactor: Remove condition blocks and switch-cases for enums
- [bc2100d](https://github.com/thevickypedia/Filebrowser-iOS/commit/bc2100d1780b6c94d8a3f8104120576ef5063a19) chore: Update release notes for v1.29.1

v1.29.1 (08/11/2025)
--------------------
- [686dbbc](https://github.com/thevickypedia/Filebrowser-iOS/commit/686dbbcc28f8f424c705112522048d884bd674a2) chore: Release ``v1.29.1``
- [6db7bb5](https://github.com/thevickypedia/Filebrowser-iOS/commit/6db7bb5b7099cde6798a1429f2fe504239e7fa43) perf: Improve error handling and user responses for search failures
- [1c70ce7](https://github.com/thevickypedia/Filebrowser-iOS/commit/1c70ce75c53fdc0cddf6ffd1f6874c7dd3328899) chore: Update release notes for v1.29.0

v1.29.0 (08/11/2025)
--------------------
- [390fa4c](https://github.com/thevickypedia/Filebrowser-iOS/commit/390fa4cbfbfd7150f10140dabc125331947f367c) chore: Release ``v1.29.0``
- [3de6cea](https://github.com/thevickypedia/Filebrowser-iOS/commit/3de6cea86d2ba51aaf5ca2e6c5a0addd9a047329) feat: Include an option to cancel a search request that's inprogress
- [e6d961a](https://github.com/thevickypedia/Filebrowser-iOS/commit/e6d961a7c4b61de8a33804a769e1da3e74d0bbac) chore: Update release notes for v1.28.2

v1.28.2 (08/11/2025)
--------------------
- [06c0623](https://github.com/thevickypedia/Filebrowser-iOS/commit/06c062309845a5182903453aba93e335c84ae24b) chore: Release ``v1.28.2``
- [01ec775](https://github.com/thevickypedia/Filebrowser-iOS/commit/01ec7757ce871a098c8e7571f285e2cad84cc33d) style: Add an option to unselect search type and disable cancel icon when search is in progress
- [cfa9e6d](https://github.com/thevickypedia/Filebrowser-iOS/commit/cfa9e6dd428d18d9ba3ea53f2ae63746dc1b391c) chore: Update release notes for v1.28.1

v1.28.1 (08/11/2025)
--------------------
- [8473178](https://github.com/thevickypedia/Filebrowser-iOS/commit/847317854479feecff1dd7efae1060d94ed7c0a3) chore: Release ``v1.28.1``
- [a5c2f34](https://github.com/thevickypedia/Filebrowser-iOS/commit/a5c2f34d261cea3ef8171e676fee431be4a1bf4a) style: Add a checkmark against the chosen server URL
- [b84b07c](https://github.com/thevickypedia/Filebrowser-iOS/commit/b84b07cc730620b06ed077ba4e45639f9947310b) chore: Update release notes for v1.28.0

v1.28.0 (08/11/2025)
--------------------
- [0ff29c0](https://github.com/thevickypedia/Filebrowser-iOS/commit/0ff29c0a172fa0b41f4dccbdb65eac8899ed3365) chore: Release ``v1.28.0``
- [f8c707d](https://github.com/thevickypedia/Filebrowser-iOS/commit/f8c707d0a234449bba6b3e498be349830428872f) feat: Include current location in search functionality
- [083308d](https://github.com/thevickypedia/Filebrowser-iOS/commit/083308d6f91bf5efee93c579fcabc8472c6cddd4) chore: Update release notes for v1.27.0

v1.27.0 (08/11/2025)
--------------------
- [19e9ace](https://github.com/thevickypedia/Filebrowser-iOS/commit/19e9acea056c2420b33034a36f04628382c67175) chore: Release ``v1.27.0``
- [b6f190a](https://github.com/thevickypedia/Filebrowser-iOS/commit/b6f190a2c11bb795d335454b4980a2525e57297d) feat: Include an option to specify file types along with search query
- [da7eea2](https://github.com/thevickypedia/Filebrowser-iOS/commit/da7eea2edc105a265e2dd2045142f8bd191954f7) chore: Update release notes for v1.26.1

v1.26.1 (08/11/2025)
--------------------
- [a2740f0](https://github.com/thevickypedia/Filebrowser-iOS/commit/a2740f0fa53852da38f1cfb650998b39d9743b55) chore: Release ``v1.26.1``
- [9fcd10f](https://github.com/thevickypedia/Filebrowser-iOS/commit/9fcd10f20c747db53d80e6afcba19c29bbd9dccd) fix: Overflow beyond screen size in selectable text
- [ac3638e](https://github.com/thevickypedia/Filebrowser-iOS/commit/ac3638e333a53515e5031dfc1c3e59e47be5fac5) revert: Reset ``navigationTitle``
- [c7775e5](https://github.com/thevickypedia/Filebrowser-iOS/commit/c7775e5b141a2ad9a80900b4fce8b328ff286fc6) feat: Make navigation title selectable
- [a6ea8ce](https://github.com/thevickypedia/Filebrowser-iOS/commit/a6ea8ce5401ac389240949d91d176b59657d8bd5) style: Update spacing in search area
- [8974d22](https://github.com/thevickypedia/Filebrowser-iOS/commit/8974d22181c0e4ddd01c869c20a8b0eb4a172261) chore: Update release notes for v1.26.0

v1.26.0 (08/10/2025)
--------------------
- [7140fd1](https://github.com/thevickypedia/Filebrowser-iOS/commit/7140fd1b417937a41aa8de6b73099ae366604fb4) chore: Release ``v1.26.0``
- [8905a84](https://github.com/thevickypedia/Filebrowser-iOS/commit/8905a8402f32e2edcab28fda268af027431508a8) fix: Redo search functionality to be able to clear search results
- [5b091de](https://github.com/thevickypedia/Filebrowser-iOS/commit/5b091deceb35f0cc87b3a1e85197547a166f7e5e) feat: Add search functionality and refactor giant body structure
- [bc2c21e](https://github.com/thevickypedia/Filebrowser-iOS/commit/bc2c21e87ebd8e47585fb0b4cbd630ab6dcd466a) chore: Update release notes for v1.25.1

v1.25.1 (08/10/2025)
--------------------
- [b302e9e](https://github.com/thevickypedia/Filebrowser-iOS/commit/b302e9e0c75252784a8056a070b31bf83b2a47c8) chore: Release ``v1.25.1``
- [e5018df](https://github.com/thevickypedia/Filebrowser-iOS/commit/e5018dfaaec228006d7f9b0ef8d9591be8e03966) fix: Prevent loading thumbnails if already in progress or cached
- [eb4f4a1](https://github.com/thevickypedia/Filebrowser-iOS/commit/eb4f4a1b1fdf54a3fb19938890aaa4ffd7edbd18) chore: Update release notes for v1.25.0

v1.25.0 (08/10/2025)
--------------------
- [f72d53b](https://github.com/thevickypedia/Filebrowser-iOS/commit/f72d53b6693a2aa228c2ef89a38ce06e5f81350d) chore: Release ``v1.25.0``
- [03fef43](https://github.com/thevickypedia/Filebrowser-iOS/commit/03fef43f6e8e58bfdc4358679699bbbacaee08b8) feat: Include a view visibility checker to load thumbnails only for images in view
- [0a75827](https://github.com/thevickypedia/Filebrowser-iOS/commit/0a7582750da865067e63d08c33ffa9c2c7fcebb7) chore: Update release notes for v1.24.5

v1.24.5 (08/10/2025)
--------------------
- [09f1d0f](https://github.com/thevickypedia/Filebrowser-iOS/commit/09f1d0f0dcf040445633ba51ea05a6bc0ee56a7e) chore: Release ``v1.24.5``
- [62368fb](https://github.com/thevickypedia/Filebrowser-iOS/commit/62368fbc270484d7291c77de9e465e3d9ffdfa5b) fix: Clear cache button clears the cache only for current server
- [9a79a00](https://github.com/thevickypedia/Filebrowser-iOS/commit/9a79a000a1225ada5a1dba1bb3780601d155f376) fix: Retrieve preview and raw from cache only when caching is enabled
- [8addf23](https://github.com/thevickypedia/Filebrowser-iOS/commit/8addf23ef899c9b39e0ddede56635bb5d15ceff3) chore: Update release notes for v1.24.4

v1.24.4 (08/10/2025)
--------------------
- [9b2b9df](https://github.com/thevickypedia/Filebrowser-iOS/commit/9b2b9df8bf1f0e81b8efe553d50133afa410007d) chore: Release ``v1.24.4``
- [dc59552](https://github.com/thevickypedia/Filebrowser-iOS/commit/dc595524c5930ee777d1c449762cc7ccbda1a90c) ci: Disable code coverage, enable parallel testing and skip package updates when running tests in GHA
- [d9b1bc0](https://github.com/thevickypedia/Filebrowser-iOS/commit/d9b1bc08cc34daf33df4623fc7d842c3aa5a0471) feat: Disable add new server button when limit (5) is reached
- [bca5ec2](https://github.com/thevickypedia/Filebrowser-iOS/commit/bca5ec22193123ead40e50176ac8f02a522cc177) feat: Limit adding new servers to 5 count
- [819e917](https://github.com/thevickypedia/Filebrowser-iOS/commit/819e9173d2336d579740f5c609163a3230df6656) style: Make list of known servers under deletion sheet scroll-able
- [ba04bea](https://github.com/thevickypedia/Filebrowser-iOS/commit/ba04bea8d2aa75afd900df3ebaeae6f8ce528961) feat: Allow deleting known servers individually
- [6cbb4e4](https://github.com/thevickypedia/Filebrowser-iOS/commit/6cbb4e497605be4d0ffd84e816f8f3b17895519c) chore: Update release notes for v1.24.3

v1.24.3 (08/10/2025)
--------------------
- [5a5fbe3](https://github.com/thevickypedia/Filebrowser-iOS/commit/5a5fbe33873ff150198bde1f2fcacb28a7df5241) chore: Release ``v1.24.3``
- [8d01a52](https://github.com/thevickypedia/Filebrowser-iOS/commit/8d01a52b23c0692dfdbc2c2aa7a5b1f0464d846c) fix: Support different timestamps to display date in grid view
- [afd6075](https://github.com/thevickypedia/Filebrowser-iOS/commit/afd6075b15b0e0b1f4f808bb2af2e7fe8b4f7cd9) style: Truncate server URL at tail
- [8298eee](https://github.com/thevickypedia/Filebrowser-iOS/commit/8298eeedbcfeda9dafc853c8b3b0ef2306ca63e2) refactor: Display last logged in ``serverURL`` as the first option instead of first added
- [55d8148](https://github.com/thevickypedia/Filebrowser-iOS/commit/55d81480d4c3dd58d017841dccc0a01a1f24dc7f) style: Update server URL drop down to be the same size as text area
- [1029a2b](https://github.com/thevickypedia/Filebrowser-iOS/commit/1029a2bc4b5d6ee4f29cbf1a2c4fef793a71bae6) refactor: Move select button inside options menu
- [094b5c0](https://github.com/thevickypedia/Filebrowser-iOS/commit/094b5c0ab4cdce9a1773fe2b23c729461236cfb4) style: Display login errors in alert windows
- [7f5b75b](https://github.com/thevickypedia/Filebrowser-iOS/commit/7f5b75bfd2e376519c7d77b918dc6b85f69afaf5) chore: Update release notes for v1.24.2

v1.24.2 (08/10/2025)
--------------------
- [6be9921](https://github.com/thevickypedia/Filebrowser-iOS/commit/6be992110301b0d3317691d245359b1b87ed39ce) chore: Release ``v1.24.2``
- [8a81fca](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a81fca64b7266a3c6a1e110bfce6de95ee5b71a) fix: Ensure credentials are not empty before server connection
- [7da409f](https://github.com/thevickypedia/Filebrowser-iOS/commit/7da409f14f1989358bbaf88141114586179274b7) fix: Catch invalid URLs when adding a new one
- [00c9d3e](https://github.com/thevickypedia/Filebrowser-iOS/commit/00c9d3e0439d4b3fcd7818a4b962e6cb70133761) chore: Update release notes for v1.24.1

v1.24.1 (08/10/2025)
--------------------
- [412ccfd](https://github.com/thevickypedia/Filebrowser-iOS/commit/412ccfd8b8260e968db760905304fcbc1008316d) chore: Release ``v1.24.1``
- [4a1c021](https://github.com/thevickypedia/Filebrowser-iOS/commit/4a1c0219fe5f79b0c756a33633ceaa554eb4452b) fix: Bug fix on sharing JWT between servers
- [ccb98e8](https://github.com/thevickypedia/Filebrowser-iOS/commit/ccb98e80613a1c0ff3a8581af85148a01e3d45fe) chore: Update release notes for v1.24.0

v1.24.0 (08/09/2025)
--------------------
- [37fb951](https://github.com/thevickypedia/Filebrowser-iOS/commit/37fb95152272d2b999d66ce8e82ef0dacec3ad7b) chore: Release ``v1.24.0``
- [dfdeb48](https://github.com/thevickypedia/Filebrowser-iOS/commit/dfdeb48fd2173ac7da3656829c9c5921de0358e2) feat: Store caching dedicated to current server
- [d0687bc](https://github.com/thevickypedia/Filebrowser-iOS/commit/d0687bc69ac78504f82f66ac576610c6400144c3) chore: Update release notes for v1.23.4

v1.23.4 (08/09/2025)
--------------------
- [e0087f0](https://github.com/thevickypedia/Filebrowser-iOS/commit/e0087f0bf243bfb9d0f6f22d14efe3e6e55e7656) chore: Release ``v1.23.4``
- [64456e2](https://github.com/thevickypedia/Filebrowser-iOS/commit/64456e204674e60a314d63896212f2043add8f05) style: Disable remember me button when face ID is toggled
- [d62fb0d](https://github.com/thevickypedia/Filebrowser-iOS/commit/d62fb0db1442774b391c1bad62c616ad312cfd1f) chore: Update release notes for v1.23.3

v1.23.3 (08/09/2025)
--------------------
- [c25b300](https://github.com/thevickypedia/Filebrowser-iOS/commit/c25b300af278dbe50b2f693c24ba4e9f8fe12ad1) chore: Release ``v1.23.3``
- [2355bd9](https://github.com/thevickypedia/Filebrowser-iOS/commit/2355bd9027bb78df61a55ab2850edcf2de7e6af1) fix: Remember me option should retain only the username for best practices
- [0687df5](https://github.com/thevickypedia/Filebrowser-iOS/commit/0687df56958dfb916b1a63d77084435e75e0c944) style: Distinguish status message between session vs session and known servers cleared
- [059c66f](https://github.com/thevickypedia/Filebrowser-iOS/commit/059c66f1c902b948b8c0f3bd72b5556409481f8f) style: Replace default alert window with sheet for better user experience
- [c741517](https://github.com/thevickypedia/Filebrowser-iOS/commit/c74151765288eb835b34abdad5fe53c40d0b3500) refactor: Move server url menu's alert context into it's dedicated module
- [e8b9fe6](https://github.com/thevickypedia/Filebrowser-iOS/commit/e8b9fe6ecd89899c579123b075dc81dac8463e79) chore: Update release notes for v1.23.2

v1.23.2 (08/09/2025)
--------------------
- [ff1250d](https://github.com/thevickypedia/Filebrowser-iOS/commit/ff1250d2adb3bfdad6acc01b91bdad44ad49f685) chore: Release ``v1.23.2``
- [4f52421](https://github.com/thevickypedia/Filebrowser-iOS/commit/4f52421dd17a52f2d6fae9e297ad43c9586ad13e) fix: Remove ``serverURL`` and ``knownServers`` in active state when requested from settings view
- [cb33c05](https://github.com/thevickypedia/Filebrowser-iOS/commit/cb33c0512bac6065c5f0bda750be8747bba8179c) style: Restructure ``serverURL`` menu to look similar to legacy text box
- [2282a96](https://github.com/thevickypedia/Filebrowser-iOS/commit/2282a96fee8a42c32fc8436a9569f6b03be3b89d) style: Include a message box for session deletion confirmation
- [25099c5](https://github.com/thevickypedia/Filebrowser-iOS/commit/25099c57248336f26ebf83336976a6600ea99d8d) chore: Update release notes for v1.23.1

v1.23.1 (08/09/2025)
--------------------
- [5f63944](https://github.com/thevickypedia/Filebrowser-iOS/commit/5f6394485cfcdf15873a414fda573512e8478b54) chore: Release ``v1.23.1``
- [164ec68](https://github.com/thevickypedia/Filebrowser-iOS/commit/164ec68a3d6d6febab5ecf27b1d55d0343946d1f) feat: Include an option to clear known servers along with stored session
- [c0aefce](https://github.com/thevickypedia/Filebrowser-iOS/commit/c0aefceebabdcff52e9f221478c2d7c8073ff8f2) chore: Update release notes for v1.23.0

v1.23.0 (08/09/2025)
--------------------
- [189517a](https://github.com/thevickypedia/Filebrowser-iOS/commit/189517ac621b594c6b7a44b0a493a840c638498a) chore: Release ``v1.23.0``
- [e6f4305](https://github.com/thevickypedia/Filebrowser-iOS/commit/e6f430590c2a3a79c9e13d98515281c60335adbe) feat: Store a list of known servers and re-use
- [7595e88](https://github.com/thevickypedia/Filebrowser-iOS/commit/7595e88b865721165cb474c5571809a262e10c8c) fix: Remove logging token info inside an un-awaited async block
- [f65ba6a](https://github.com/thevickypedia/Filebrowser-iOS/commit/f65ba6a0f70429f1e54ccf616f23e17f23ec0568) fix: Remove automatic session restoration
- [841f643](https://github.com/thevickypedia/Filebrowser-iOS/commit/841f6431e049a6b3eaf25d47252f884a9cfe9f43) feat: Allow users to clear keychain from within settings view
- [fade930](https://github.com/thevickypedia/Filebrowser-iOS/commit/fade9309cc1a64ff0e5b581b8809869fcb9a332e) fix: Remove ``onAppear`` login and remembering username
- [8c671cb](https://github.com/thevickypedia/Filebrowser-iOS/commit/8c671cbc32482c2f5d50dc54862891bdb90a51ef) chore: Update release notes for v1.22.5

v1.22.5 (08/09/2025)
--------------------
- [1c5534b](https://github.com/thevickypedia/Filebrowser-iOS/commit/1c5534b168b53e66f069e9de36b6de110945612e) chore: Release ``v1.22.5``
- [b32e3bb](https://github.com/thevickypedia/Filebrowser-iOS/commit/b32e3bbe8c0e06e9b2d26dcc10592140bf993bb9) fix: Face ID failing silently when session expires
- [4694901](https://github.com/thevickypedia/Filebrowser-iOS/commit/46949017f8a93072d82db887c982ff95be77c6c4) refactor: Merge path and pathStack into a single source of truth
- [c0ca5cb](https://github.com/thevickypedia/Filebrowser-iOS/commit/c0ca5cbd34fb310acd1759486c1bacfccbc65779) fix: Fix home page pointing to last stack
- [83f7ccc](https://github.com/thevickypedia/Filebrowser-iOS/commit/83f7cccc8b62c6e85b7081a539b58eda5713702f) chore: Update release notes for v1.22.4

v1.22.4 (08/09/2025)
--------------------
- [d6d5af7](https://github.com/thevickypedia/Filebrowser-iOS/commit/d6d5af7740b72581c294a32791cb4049f9312a4d) chore: Release ``v1.22.4``
- [27279f9](https://github.com/thevickypedia/Filebrowser-iOS/commit/27279f9b3ca0f8ad3fe49c21e18a43d76c9dfb3f) feat: Retain selected view mode in app storage
- [bfce042](https://github.com/thevickypedia/Filebrowser-iOS/commit/bfce0425f57db1894613eb88d19b0e02bea40003) fix: Restore session information in settings view for FaceID logins
- [49b331d](https://github.com/thevickypedia/Filebrowser-iOS/commit/49b331d14ac27daf3b4c281c06811dd8b088b7a1) chore: Update release notes for v1.22.3

v1.22.3 (08/09/2025)
--------------------
- [388bc18](https://github.com/thevickypedia/Filebrowser-iOS/commit/388bc18cca671ba4bffb267a4a2f05fad9158336) chore: Release ``v1.22.3``
- [736e181](https://github.com/thevickypedia/Filebrowser-iOS/commit/736e1810e2a0b51ba34cb890394104bfeb52eb99) style: Include file size in grid view
- [f74ac4e](https://github.com/thevickypedia/Filebrowser-iOS/commit/f74ac4ee09652613be7fd2c75b58d688ebe19b91) style: Display modified date in grid view
- [747530c](https://github.com/thevickypedia/Filebrowser-iOS/commit/747530c7bcb31cf4fa9d519054c19e301a8d34ae) perf: Retrieve file information only when required
- [d5bedbd](https://github.com/thevickypedia/Filebrowser-iOS/commit/d5bedbd6378766f8f9c9bb394fe17eab800774d1) chore: Update release notes for v1.22.2

v1.22.2 (08/09/2025)
--------------------
- [83307b3](https://github.com/thevickypedia/Filebrowser-iOS/commit/83307b3e7730bfbc61273d30dd50816fb58edc96) chore: Release ``v1.22.2``
- [259f42d](https://github.com/thevickypedia/Filebrowser-iOS/commit/259f42d2de6c3785bc7ae5a334d8781630b78f0d) fix: Remove redundant logout logic
- [899d3f4](https://github.com/thevickypedia/Filebrowser-iOS/commit/899d3f4a5866302a019875edff40e741bd1d1801) fix: Remove error message when faceID fails
- [3ff25cf](https://github.com/thevickypedia/Filebrowser-iOS/commit/3ff25cf65dd2a7b5ea05f2891d88f474e620194d) fix: Avoid automatically logging in when FaceID is registered
- [9680221](https://github.com/thevickypedia/Filebrowser-iOS/commit/96802218d65f5635dccee048ea57dfcc8b7e5f21) fix: Set a fallback for username and password if FaceID fails
- [d3b91ac](https://github.com/thevickypedia/Filebrowser-iOS/commit/d3b91ac67affba16ee5a3ef85a2629edf63b46b1) chore: Update release notes for v1.22.1

v1.22.1 (08/09/2025)
--------------------
- [2199136](https://github.com/thevickypedia/Filebrowser-iOS/commit/219913619165cf73b52396fc80182d1e72953693) chore: Release ``v1.22.1``
- [04c9c5c](https://github.com/thevickypedia/Filebrowser-iOS/commit/04c9c5cfdc18db7f1bbef4d12757ad9790291c6d) fix: Check for saved session before giving an option for FaceID
- [0673e8c](https://github.com/thevickypedia/Filebrowser-iOS/commit/0673e8caa3878972c3be7cb1a366f0b6d16b6125) fix: Make Face ID button visible
- [4dec964](https://github.com/thevickypedia/Filebrowser-iOS/commit/4dec9646d84609926524fd1f963dbfcdd6d37bc6) perf: Improve the usage for Face ID based on a top level var
- [adfc197](https://github.com/thevickypedia/Filebrowser-iOS/commit/adfc197fbd6a18f5ab0ae63cf56680aa41e3e451) chore: Update release notes for v1.22.0

v1.22.0 (08/09/2025)
--------------------
- [594b62f](https://github.com/thevickypedia/Filebrowser-iOS/commit/594b62f3d64b3f9db08c7e5f637be4e1d281d9ce) chore: Release ``v1.22.0``
- [5972b91](https://github.com/thevickypedia/Filebrowser-iOS/commit/5972b91cf51375cad9fcdb43b0312472e0d520f2) feat: Include support for Face ID
- [a9952d9](https://github.com/thevickypedia/Filebrowser-iOS/commit/a9952d9392e5c49ca76b68b318a3caf313d6f38a) revert: Revert refactor for individual modules
- [1a1a558](https://github.com/thevickypedia/Filebrowser-iOS/commit/1a1a5588da738ba2c769177e1d4996ec6cea4263) refactor: Create individual modules for cell and thumbnail views
- [29d6971](https://github.com/thevickypedia/Filebrowser-iOS/commit/29d697135f8b6d80dced8d536b9bca8976ad87e6) chore: Update release notes for v1.21.3

v1.21.3 (08/09/2025)
--------------------
- [978d3b1](https://github.com/thevickypedia/Filebrowser-iOS/commit/978d3b1d8e8ed19213932d21a871941a854113e7) chore: Release ``v1.21.3``
- [f59bcfa](https://github.com/thevickypedia/Filebrowser-iOS/commit/f59bcfae47c8330883e32206dc7ad80d6231819c) fix: Swipe animation direction for detailed view
- [d97dd9c](https://github.com/thevickypedia/Filebrowser-iOS/commit/d97dd9ccbf29edf4cfda233ea4755ae9951bd3a6) chore: Update release notes for v1.21.2

v1.21.2 (08/08/2025)
--------------------
- [6b6862f](https://github.com/thevickypedia/Filebrowser-iOS/commit/6b6862f56683ecf6b74b28db5d3e75a5964fe286) chore: Release ``v1.21.2``
- [6bbce9c](https://github.com/thevickypedia/Filebrowser-iOS/commit/6bbce9cc252cee0ddd204174af853a3eac996c26) fix: Include dedicated swiping logic in image preview
- [cf8ca57](https://github.com/thevickypedia/Filebrowser-iOS/commit/cf8ca575bdb699346e38d277d01484cc11b814c9) chore: Update release notes for v1.21.1

v1.21.1 (08/08/2025)
--------------------
- [89748d4](https://github.com/thevickypedia/Filebrowser-iOS/commit/89748d43e4f1f61b57506af8402bc5c63d5d7c10) chore: Release ``v1.21.1``
- [cebf916](https://github.com/thevickypedia/Filebrowser-iOS/commit/cebf9164b904277606d24b31c19c4a3a8a3cc519) style: Include pinch and double tap gestures
- [8f5d8d5](https://github.com/thevickypedia/Filebrowser-iOS/commit/8f5d8d5fc02c6812e31d8fb63b92c5a8a3d6a726) chore: Update release notes for v1.21.0

v1.21.0 (08/08/2025)
--------------------
- [c973582](https://github.com/thevickypedia/Filebrowser-iOS/commit/c9735825ec1bc344167c46e2b39b940298210bbe) chore: Release ``v1.21.0``
- [20b8c94](https://github.com/thevickypedia/Filebrowser-iOS/commit/20b8c94e302cd2ae2912a0488d3d18e69b31121b) feat: Display zoomable images in preview mode
- [0e66c52](https://github.com/thevickypedia/Filebrowser-iOS/commit/0e66c52e50866eebeeb098e87e062cdeb80440e3) chore: Update release notes for v1.20.1

v1.20.1 (08/08/2025)
--------------------
- [76e8173](https://github.com/thevickypedia/Filebrowser-iOS/commit/76e8173cd49ba139286bd3fc9369fc7fff7acb31) chore: Release ``v1.20.1``
- [cab9991](https://github.com/thevickypedia/Filebrowser-iOS/commit/cab99911ebc70245db75cb0f10ad2688b4d53792) fix: Ensure directories are excluded in drag gesture
- [17315f2](https://github.com/thevickypedia/Filebrowser-iOS/commit/17315f295958cc8fe4facb838adbb3618dfd0194) chore: Update release notes for v1.20.0

v1.20.0 (08/08/2025)
--------------------
- [c54ab2b](https://github.com/thevickypedia/Filebrowser-iOS/commit/c54ab2bcd7aa0558682e7f2a17b506aec06c4f54) chore: Release ``v1.20.0``
- [75c6434](https://github.com/thevickypedia/Filebrowser-iOS/commit/75c643490d326cfa4912c3b40e429ba1564c812a) style: Update drag gesture to iOS Photos app style
- [2232c2f](https://github.com/thevickypedia/Filebrowser-iOS/commit/2232c2f56240886712da726f687a7aaccaf4d38a) style: Add animation for drag gesture
- [c607261](https://github.com/thevickypedia/Filebrowser-iOS/commit/c607261732c415de4814ca23f6cbb5e5438c1284) chore: Update release notes for v1.19.1

v1.19.1 (08/08/2025)
--------------------
- [4f75539](https://github.com/thevickypedia/Filebrowser-iOS/commit/4f75539c52aa593cee86ce48d1861ca01b30b059) chore: Release ``v1.19.1``
- [eb0623f](https://github.com/thevickypedia/Filebrowser-iOS/commit/eb0623f9a39feb4a7f1f263b86fe7d6b86d13dee) style: Create an adaptive grid view for iPad and potrait mode
- [ea16dc3](https://github.com/thevickypedia/Filebrowser-iOS/commit/ea16dc3e3e53f6fb1f53661b67c400c79f6cfaad) refactor: Move view structs into view style module
- [29d66ba](https://github.com/thevickypedia/Filebrowser-iOS/commit/29d66ba80e075d060d4134d8ad76c4fb2df7b4c0) chore: Update release notes for v1.19.0

v1.19.0 (08/08/2025)
--------------------
- [366fa87](https://github.com/thevickypedia/Filebrowser-iOS/commit/366fa8706fb96f2160d8548093083b91612924cc) chore: Release ``v1.19.0``
- [0dd758b](https://github.com/thevickypedia/Filebrowser-iOS/commit/0dd758b97210d102a9f4109c71e224458cd9260c) feat: Support ``ViewStyle.globalScale`` adaptive for different devices and orientations
- [6ba4870](https://github.com/thevickypedia/Filebrowser-iOS/commit/6ba48707e0aecc73e1e097f9c86dc85b0dc2d735) perf: Introduce ``globalScale`` to handle ``viewStyle`` without touching multiple frames
- [cc55f02](https://github.com/thevickypedia/Filebrowser-iOS/commit/cc55f022af8ef2ab896bc0af164b751375629d1a) refactor: Use a centralized ``ViewStyle`` to handle sizing
- [ed8b068](https://github.com/thevickypedia/Filebrowser-iOS/commit/ed8b0680ff343b5d00c73e42ca349d2351057310) refactor: Reduce code redundancy
- [8409f65](https://github.com/thevickypedia/Filebrowser-iOS/commit/8409f65e5adc897f31193b34d1670dccaa9cb61a) fix: Disable navigation when ``selectionMode`` is enabled
- [5fb2e7b](https://github.com/thevickypedia/Filebrowser-iOS/commit/5fb2e7bccbc90535211321d5d181c54c49944cbd) style: Retain the original orientation when selection mode is enabled in all 3 views
- [bd4cbe2](https://github.com/thevickypedia/Filebrowser-iOS/commit/bd4cbe2f8bc5a8571cfd21126e8902fe5b438450) style: ``selectionMode`` should not shrink or alter the layout in grid/module view
- [df3f883](https://github.com/thevickypedia/Filebrowser-iOS/commit/df3f883917c75d6796fccbe7901048e02a0ca0cd) style: Display ``systemIcons`` in list view when ``selectionMode`` is enabled
- [a5b2c4a](https://github.com/thevickypedia/Filebrowser-iOS/commit/a5b2c4ae5842af1d20ed6d5ba35cf9ffa4a573c0) fix: Mismatch when fetching system icons for different file types
- [e0cf455](https://github.com/thevickypedia/Filebrowser-iOS/commit/e0cf45520d293cd948d2181d63345348024b6c0f) style: Update module view to be significantly different from grid
- [fcd4c49](https://github.com/thevickypedia/Filebrowser-iOS/commit/fcd4c499c289124f9fb1d259b35c30380c6d7b48) style: Use ``Picker`` instead of individual buttons for view options
- [73d902b](https://github.com/thevickypedia/Filebrowser-iOS/commit/73d902bc9e4bbc752e4b3558608272146b838a78) style: Update styling in grid view
- [6009caa](https://github.com/thevickypedia/Filebrowser-iOS/commit/6009caa313afe55e3417c1a00442fcca6b3bfb5c) style: Update grid view to expand thumbnail containers
- [1a9c4de](https://github.com/thevickypedia/Filebrowser-iOS/commit/1a9c4de07db00629d7dd739963522a29320eaf45) style: Update grid view to support arbritary values
- [c5329df](https://github.com/thevickypedia/Filebrowser-iOS/commit/c5329df2c66edd2831317e54bbbdcb37cb72e403) refactor: Move grid size options to func level variables
- [32153b3](https://github.com/thevickypedia/Filebrowser-iOS/commit/32153b3d8cff4d355a3a45d38d79a606d06164de) style: Add a new view option ``module``
- [5da1137](https://github.com/thevickypedia/Filebrowser-iOS/commit/5da1137bc10d68052b33079c61409c3ab0ffeecd) style: Move view options button inside it's own menu
- [23ecfbd](https://github.com/thevickypedia/Filebrowser-iOS/commit/23ecfbd5c52a3cda5bc1035341e87c37d19462c6) chore: Update release notes for v1.18.0

v1.18.0 (08/08/2025)
--------------------
- [798b03c](https://github.com/thevickypedia/Filebrowser-iOS/commit/798b03c7d7482c32431bf4f97ff9ec549db62753) chore: Release ``v1.18.0``
- [adef899](https://github.com/thevickypedia/Filebrowser-iOS/commit/adef89970200ad9dd7c1ca34506b909ee7100ff9) style: Include an option to arbitrarily resize thumbnails to fit grid view
- [ac38dd0](https://github.com/thevickypedia/Filebrowser-iOS/commit/ac38dd0d7cb98389d40160525bc941b6c135864f) style: Improve styling in grid view
- [4e21966](https://github.com/thevickypedia/Filebrowser-iOS/commit/4e21966337563716554ba1617dc35e2319a18417) fix: Get grid view working for file and folder navigation
- [c0f0440](https://github.com/thevickypedia/Filebrowser-iOS/commit/c0f0440404b5dbf90dc5d066a027ab958d7b4a14) fix: Replicate list view coding options in grid
- [8268235](https://github.com/thevickypedia/Filebrowser-iOS/commit/826823597e796317acbe1440055480e968c43891) style: Improve error message when failed to parse file list
- [a23ab76](https://github.com/thevickypedia/Filebrowser-iOS/commit/a23ab7686c3ed5454aaeb5f4db47332716dd57a2) feat: Include a view option for list vs grid types
- [c9f4369](https://github.com/thevickypedia/Filebrowser-iOS/commit/c9f436991431f501a519223971a6ba5e01be33ed) chore: Update release notes for v1.17.1

v1.17.1 (08/07/2025)
--------------------
- [6bf1c09](https://github.com/thevickypedia/Filebrowser-iOS/commit/6bf1c09c94648e21bb0e6a465245437a23c47cec) chore: Release ``v1.17.1``
- [8ecf94e](https://github.com/thevickypedia/Filebrowser-iOS/commit/8ecf94e1532bab579468da123ccc51789a17e2eb) style: Update status messages
- [bcc7cf4](https://github.com/thevickypedia/Filebrowser-iOS/commit/bcc7cf49a19f89fd8451ce28d3a81d64cb02d170) fix: Ensure preparing to upload banner is reset after interval
- [91b7a04](https://github.com/thevickypedia/Filebrowser-iOS/commit/91b7a04fd7b79520f14d559dece64aa68a3dc902) style: Minor updates to upload status
- [0aaeb20](https://github.com/thevickypedia/Filebrowser-iOS/commit/0aaeb201d7f882189da5b5d2af0a4f20642a5444) style: Include more status indicators
- [e66e5e5](https://github.com/thevickypedia/Filebrowser-iOS/commit/e66e5e546609285e7152833c7b7f41e17c5d3e7f) chore: Update release notes for v1.17.0

v1.17.0 (08/07/2025)
--------------------
- [cf33552](https://github.com/thevickypedia/Filebrowser-iOS/commit/cf33552fc108ed7589bb7719d9ae4b55fa471d49) chore: Release ``v1.17.0``
- [7ee4237](https://github.com/thevickypedia/Filebrowser-iOS/commit/7ee42372c8219ff4e76ef8c53de854410e71e15d) feat: Display disappearing lables to indicate status in settings page
- [c2ae5f8](https://github.com/thevickypedia/Filebrowser-iOS/commit/c2ae5f8a375ee5e3cdda58f481bbc0d445c505b0) chore: Update release notes for v1.16.6

v1.16.6 (08/07/2025)
--------------------
- [28821cf](https://github.com/thevickypedia/Filebrowser-iOS/commit/28821cf36015e1733100c1581b9299a330e550d0) chore: Release ``v1.16.6``
- [8d30264](https://github.com/thevickypedia/Filebrowser-iOS/commit/8d302641d37b205d5acb48aa420d7f2f475140ac) lint: Make linting happy
- [9456a59](https://github.com/thevickypedia/Filebrowser-iOS/commit/9456a595e51a12328495c0d5d9abbcf77341f54e) style: Improve the text options view to modify font and size
- [00fad44](https://github.com/thevickypedia/Filebrowser-iOS/commit/00fad44dfb42ec2adfb9e5497e965317a9f8d392) feat: Add a new feature to change font and size for text files
- [0c498b1](https://github.com/thevickypedia/Filebrowser-iOS/commit/0c498b1f5c47546fba1e01f6768969629b663c62) feat: Implement copyable text view to improve reading experience
- [c2d04c7](https://github.com/thevickypedia/Filebrowser-iOS/commit/c2d04c7c4f5a055ea54ff8a5b9fd4cb985e4c8e7) feat: Make all text attributes copy-able
- [2f3b0bd](https://github.com/thevickypedia/Filebrowser-iOS/commit/2f3b0bda046693d6598df5fff4d61aa06e89c174) revert: Binary check on text files
- [e5d8819](https://github.com/thevickypedia/Filebrowser-iOS/commit/e5d8819c84b0f38e09e5c9653919089b9a7a9cb1) feat: Include a binary check on text files to avoid misrepresented extensions causing memory leak
- [6e9f343](https://github.com/thevickypedia/Filebrowser-iOS/commit/6e9f343bf4bc6eb28fb02461fe6d63383ac7f2f2) chore: Update release notes for v1.16.5

v1.16.5 (08/07/2025)
--------------------
- [3d9280e](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d9280eafb354c75e15bfd3f263d51488c47f80f) chore: Release ``v1.16.5``
- [7653446](https://github.com/thevickypedia/Filebrowser-iOS/commit/7653446cbbf9739e8d19680c460ace6600c7650f) style: Update styling on session information
- [88be7ec](https://github.com/thevickypedia/Filebrowser-iOS/commit/88be7ec6e58d6c14f34a601cb75b5b94c58d688c) refactor: Replace condition blocks with function calls for session information
- [27b4e68](https://github.com/thevickypedia/Filebrowser-iOS/commit/27b4e68f70f734e3c8be6496669dafc5f3bab8fd) style: Parse JWT to display session information in settings view
- [2414f6b](https://github.com/thevickypedia/Filebrowser-iOS/commit/2414f6b5f0ea23fbd3de0c3f69a4117e9ddeaa92) chore: Update release notes for v1.16.4

v1.16.4 (08/07/2025)
--------------------
- [e3403f3](https://github.com/thevickypedia/Filebrowser-iOS/commit/e3403f3d5a898ad7b2394569b21c729044b30fe1) chore: Release ``v1.16.4``
- [8b6b4cc](https://github.com/thevickypedia/Filebrowser-iOS/commit/8b6b4cc609060d422a43226b25008bc56a8a36e0) style: Include a percentage indicator in upload progress view
- [3c997a2](https://github.com/thevickypedia/Filebrowser-iOS/commit/3c997a270d5cda96fee8f0e9e0b917fd561b81bd) chore: Update release notes for v1.16.3

v1.16.3 (08/07/2025)
--------------------
- [aa1c7dc](https://github.com/thevickypedia/Filebrowser-iOS/commit/aa1c7dc927d93edab4061ed67cd7ee19e0f70525) chore: Release ``v1.16.3``
- [5564806](https://github.com/thevickypedia/Filebrowser-iOS/commit/55648066795581518131b52b58515e56562cd405) perf: Replace giant condition block for ``systemIcons`` with a dictionary
- [2704748](https://github.com/thevickypedia/Filebrowser-iOS/commit/2704748d9dcd7b8f0629fb0a06348a743e79c71b) chore: Extend UTF8 text formats for supported extensions
- [464ef16](https://github.com/thevickypedia/Filebrowser-iOS/commit/464ef160ecdbd027a48aaa845286c6e0ddc247c9) chore: Extend system icons
- [86ccb15](https://github.com/thevickypedia/Filebrowser-iOS/commit/86ccb15a4f469e8dbed50097742c21f47e5cb7e6) chore: remove non-UTF8 text formats from supported extensions
- [637656c](https://github.com/thevickypedia/Filebrowser-iOS/commit/637656c2eb7d8e86df3d0fe2b0b9404ea5a15192) style: Display a preparing for upload banner to cover propagation delay
- [706c464](https://github.com/thevickypedia/Filebrowser-iOS/commit/706c4641d1863c06767d32d7d3d1a7f23e359fa4) style: Display current uploaded file size along with total file size in upload progress view
- [ef8d8ea](https://github.com/thevickypedia/Filebrowser-iOS/commit/ef8d8ea57f0cdcc96908ba9b80b43d6df06b242b) fix: Avoid remembering password
- [bd9470c](https://github.com/thevickypedia/Filebrowser-iOS/commit/bd9470c233942dbb7a772b3de0dd68c81c0d137e) style: Show file type icons during file upload progress view
- [b369cd9](https://github.com/thevickypedia/Filebrowser-iOS/commit/b369cd9a6b51928a7001c53b96159fe17e714ffe) chore: Update release notes for v1.16.2

v1.16.2 (08/06/2025)
--------------------
- [40f9c82](https://github.com/thevickypedia/Filebrowser-iOS/commit/40f9c823194f29acb968a3c18e57f1815d10fe7c) chore: Release ``v1.16.2``
- [1f1b905](https://github.com/thevickypedia/Filebrowser-iOS/commit/1f1b9050072d79e0a56a7fca9168390f27f84813) ci: Avoid running linter for each change
- [5a73ab6](https://github.com/thevickypedia/Filebrowser-iOS/commit/5a73ab67c64782fbe777b828d40855374e0e2ae8) perf: Switch caching mechanism to memory-mapped loading
- [12a839f](https://github.com/thevickypedia/Filebrowser-iOS/commit/12a839f2640e4ee70ab9dd1274adb935dede986d) refactor: Set generic loading label for media progress view
- [19cdbbe](https://github.com/thevickypedia/Filebrowser-iOS/commit/19cdbbed54374272cd515ee7104807b73fc39508) refactor: Cap chunk size options
- [0ec93eb](https://github.com/thevickypedia/Filebrowser-iOS/commit/0ec93eb07dc64ea48ee8a4f2f8068e3e11cc1d8e) chore: Update release notes for v1.16.1

v1.16.1 (08/06/2025)
--------------------
- [446a4bb](https://github.com/thevickypedia/Filebrowser-iOS/commit/446a4bb21823c00880902b3d52519b60fdc04657) chore: Release ``v1.16.1``
- [e5942b9](https://github.com/thevickypedia/Filebrowser-iOS/commit/e5942b9ffcf0fa86bc5c9538e9b4d4960021f427) style: Include a new toggle button to enable/disable thumbnails
- [c7b762c](https://github.com/thevickypedia/Filebrowser-iOS/commit/c7b762cad7ab8eeddb50a0775209f55442f53bc2) fix: Fix disabling thumbnail cache automatically disabling thumbnails
- [7c74c9a](https://github.com/thevickypedia/Filebrowser-iOS/commit/7c74c9a3ab5aa475d22dce025155e90df7aa2576) chore: Update release notes for v1.16.0

v1.16.0 (08/06/2025)
--------------------
- [2b07c9f](https://github.com/thevickypedia/Filebrowser-iOS/commit/2b07c9fdf2f773a9f209ada594c11571e3ac751d) chore: Release ``v1.16.0``
- [b89a0b7](https://github.com/thevickypedia/Filebrowser-iOS/commit/b89a0b7fa201f15ad567e971487c2a93900756f5) refactor: Move format bytes to utils
- [f0b848c](https://github.com/thevickypedia/Filebrowser-iOS/commit/f0b848c6cbc0e93ee1546b4bfd3a3d86593f540a) refactor: Move alert modifiers into reusable view modifiers
- [9da5ba1](https://github.com/thevickypedia/Filebrowser-iOS/commit/9da5ba1d42c50f9be70a1dea049e33a22e883ca9) style: Re-define the upload progress bar view
- [42eeca0](https://github.com/thevickypedia/Filebrowser-iOS/commit/42eeca03c9f8045230233380cd72f6b60f77d182) style: Change display styling for upload progress
- [c8a052d](https://github.com/thevickypedia/Filebrowser-iOS/commit/c8a052dd113e83e62f4e19b916b0d70bbc607c83) style: Display current upload file's name and size in progress bar
- [fb2ce13](https://github.com/thevickypedia/Filebrowser-iOS/commit/fb2ce138256c4cf16897aa189c318633e8712f74) style: Show sorting icon only when directory contains more than one file
- [0cf0801](https://github.com/thevickypedia/Filebrowser-iOS/commit/0cf08016bb809969ab491c791d02829af1d5aae7) fix: Move upload start time to function var to avoid race condition during multi file uploads
- [557a39a](https://github.com/thevickypedia/Filebrowser-iOS/commit/557a39abbac6943cc7f612682abe6eda602b95df) feat: Display current upload speed
- [72d2dfb](https://github.com/thevickypedia/Filebrowser-iOS/commit/72d2dfb4e01697b88e38347ea1ad946cee29bd19) chore: Update release notes for v1.15.2

v1.15.2 (08/06/2025)
--------------------
- [18c4ef1](https://github.com/thevickypedia/Filebrowser-iOS/commit/18c4ef1c097b81900ea5fcda3249f1b20a894e5d) chore: Release ``v1.15.2``
- [b832181](https://github.com/thevickypedia/Filebrowser-iOS/commit/b8321813db59713067ca8c53b31d8d51cc9dddce) style: Remove unused optional bindings
- [5553d68](https://github.com/thevickypedia/Filebrowser-iOS/commit/5553d682ffbeba818a5af931fdb0ab9e2ac72fa0) refactor: Remove conditional alerting and make it default
- [6e4f474](https://github.com/thevickypedia/Filebrowser-iOS/commit/6e4f4747cc398045240dcad22ae6b00d5f36e7b3) chore: Add more alerts in the UI for network/client/server errors
- [5d2cfe0](https://github.com/thevickypedia/Filebrowser-iOS/commit/5d2cfe0fb78512cff3adc44fb48d4cd929fba9b8) chore: Update release notes for v1.15.1

v1.15.1 (08/06/2025)
--------------------
- [2e128ba](https://github.com/thevickypedia/Filebrowser-iOS/commit/2e128ba62fb30c0570c8611b30ec904b5b23109b) chore: Release ``v1.15.1``
- [b75b94d](https://github.com/thevickypedia/Filebrowser-iOS/commit/b75b94d75be52226cab9faf62e6b709e8e5874b4) perf: Move file handling logic before initiating TUS upload
- [11eb9bd](https://github.com/thevickypedia/Filebrowser-iOS/commit/11eb9bd39fd0127fcdeae704bf5a5966b39f6278) chore: Update release notes for v1.15.0

v1.15.0 (08/06/2025)
--------------------
- [85e6301](https://github.com/thevickypedia/Filebrowser-iOS/commit/85e630118fe01809e47f04da2891f381512225fd) chore: Release ``v1.15.0``
- [8b62f05](https://github.com/thevickypedia/Filebrowser-iOS/commit/8b62f0568e62e89d974bbe7489670d8344e5ee57) feat: Users are now notified about server/network errors
- [2f29252](https://github.com/thevickypedia/Filebrowser-iOS/commit/2f292529e8ef61b8fb9140b60342d903d880750a) fix: Ensure navigation title is always displayed and current
- [b0ed26a](https://github.com/thevickypedia/Filebrowser-iOS/commit/b0ed26a239c4da4037a5d0a00a7b87d8d007c5dc) fix: Missing or invalid navigation title in home page
- [5f14207](https://github.com/thevickypedia/Filebrowser-iOS/commit/5f142079a86dea8b667c0f71c5a5fb89d12ca955) fix: Clear navigation stack during logout
- [cd8fed3](https://github.com/thevickypedia/Filebrowser-iOS/commit/cd8fed3d441f7b9bbb94b688339172635cadbaf6) chore: Update release notes for v1.14.0

v1.14.0 (08/06/2025)
--------------------
- [aa44149](https://github.com/thevickypedia/Filebrowser-iOS/commit/aa44149d1666d36d12906e08e7212a60be307a7c) chore: Release ``v1.14.0``
- [8a4f32b](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a4f32be8598450d01b9788bd0ba50c3aef5c60a) feat: Allow users to choose ``chunkSize`` for file uploads
- [20be4bf](https://github.com/thevickypedia/Filebrowser-iOS/commit/20be4bf6b7c706e166921ecee2f10f3f78232df3) chore: Update release notes for v1.13.5

v1.13.5 (08/06/2025)
--------------------
- [d884bcb](https://github.com/thevickypedia/Filebrowser-iOS/commit/d884bcb0c6f23e39c70dc5ff39d4fcec3bb3d84f) chore: Release ``v1.13.5``
- [53b5a25](https://github.com/thevickypedia/Filebrowser-iOS/commit/53b5a2592a665aa13c20601ca6f99f737d31c305) style: Re-arrange icons in list and detail view
- [97ffffe](https://github.com/thevickypedia/Filebrowser-iOS/commit/97ffffe5d048aa6e7010b1ddf83fc8b303ec547a) chore: Update release notes for v1.13.4

v1.13.4 (08/06/2025)
--------------------
- [9bf7512](https://github.com/thevickypedia/Filebrowser-iOS/commit/9bf7512c60155120084c66f7770a2d5f9ae71faf) chore: Release ``v1.13.4``
- [d5af71c](https://github.com/thevickypedia/Filebrowser-iOS/commit/d5af71cd01807792f3a64d680b2e52ef964fabea) style: Display only the relevant icons in selection mode
- [72ab4b9](https://github.com/thevickypedia/Filebrowser-iOS/commit/72ab4b9a9e2ba3a32ab2e41c926fc650e2aa4a6d) chore: Update release notes for v1.13.3

v1.13.3 (08/06/2025)
--------------------
- [35f3b14](https://github.com/thevickypedia/Filebrowser-iOS/commit/35f3b14449b607040926c754fbf0c527cf9558f0) chore: Release ``v1.13.3``
- [3f905f9](https://github.com/thevickypedia/Filebrowser-iOS/commit/3f905f93f855c6ed85af90c16d62a367718a10af) refactor: Update coding standards to honor linter
- [3f2ba7f](https://github.com/thevickypedia/Filebrowser-iOS/commit/3f2ba7f38f92b3cd7fcddad5f76bb90bb3fc828a) refactor: Run linter with ``autocorrect``
- [cf6d02d](https://github.com/thevickypedia/Filebrowser-iOS/commit/cf6d02d738ffaf85e254146a69c586ac76739e64) ci: Set dependency on linting for control workflow
- [5cea25c](https://github.com/thevickypedia/Filebrowser-iOS/commit/5cea25cb16752f225057f08e3d18d54dca1fa2bb) ci: Onboard a Swift linter
- [33a83a8](https://github.com/thevickypedia/Filebrowser-iOS/commit/33a83a84b622b68a92b5c383d5a14281e8b8386e) chore: Update release notes for v1.13.2

v1.13.2 (08/05/2025)
--------------------
- [4a86555](https://github.com/thevickypedia/Filebrowser-iOS/commit/4a86555049c9b23a416eec849b6a5cbc570fdacd) chore: Release ``v1.13.2``
- [538b72e](https://github.com/thevickypedia/Filebrowser-iOS/commit/538b72ea99fc54968b6794b2d36e53326bf2f71e) fix: Use source filename for photo/video uploads with fallback set to UUID
- [1269b67](https://github.com/thevickypedia/Filebrowser-iOS/commit/1269b6789b37bd011983e7bcc87cc82d3c485757) chore: Update release notes for v1.13.1

v1.13.1 (08/05/2025)
--------------------
- [568093c](https://github.com/thevickypedia/Filebrowser-iOS/commit/568093ccbc8604cafcea0b99e395a76bcdbf7a85) chore: Release ``v1.13.1``
- [2a64fdd](https://github.com/thevickypedia/Filebrowser-iOS/commit/2a64fdd984df4d737796b40f48b3195e737e907b) feat: Allow uploading multiple photos/videos at a time
- [2cbcf34](https://github.com/thevickypedia/Filebrowser-iOS/commit/2cbcf34d97eac829f6c1ae272a6d1d6035eb9db7) chore: Update release notes for v1.13.0

v1.13.0 (08/05/2025)
--------------------
- [7405aaf](https://github.com/thevickypedia/Filebrowser-iOS/commit/7405aafa6298ee85ffd743f98c8bec0a29bbcf0e) chore: Release ``v1.13.0``
- [3d4f985](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d4f985e20acf8c0db3f618ac5919b1dcd8d69cf) feat: Add a new feature to upload from Photos application
- [7f0e974](https://github.com/thevickypedia/Filebrowser-iOS/commit/7f0e974436b71f340887a3e630945e934f84a020) test: Avoid running full client UI test suite
- [8a38b9e](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a38b9e214585e980f20a954f8528a564edfd4ec) chore: Update release notes for v1.12.6

v1.12.6 (08/05/2025)
--------------------
- [31b1705](https://github.com/thevickypedia/Filebrowser-iOS/commit/31b17054833d92af02cf31206ecf1aede289230e) chore: Release ``v1.12.6``
- [c5e9290](https://github.com/thevickypedia/Filebrowser-iOS/commit/c5e929068d7263bb520d77caf4817fd7adcdf921) ci: Remove on push triggers for individual build and test
- [2b02078](https://github.com/thevickypedia/Filebrowser-iOS/commit/2b0207845547482656dee2064e14b1f53052f972) chore: Change hyperlink for version to releases page
- [9f3178b](https://github.com/thevickypedia/Filebrowser-iOS/commit/9f3178b8356f0ab31d34d87b7bd96ffb1aa3f679) style: Set theme button to be dynamic based on system scheme
- [d495769](https://github.com/thevickypedia/Filebrowser-iOS/commit/d495769c9e806c2a985e8cd61a6d381a37dbe84e) chore: Update release notes for v1.12.5

v1.12.5 (08/05/2025)
--------------------
- [3c62e34](https://github.com/thevickypedia/Filebrowser-iOS/commit/3c62e34ab7f3b12cacd3c1b1ed757361b6b47fa4) chore: Release ``v1.12.5``
- [7dfcaf6](https://github.com/thevickypedia/Filebrowser-iOS/commit/7dfcaf6310bdc85e901560579c0625d8e0786c61) style: Set navigation title in media player to be inline
- [89c4c26](https://github.com/thevickypedia/Filebrowser-iOS/commit/89c4c26f472c57efe5ddbd825d6fdba1f09bab8f) perf: Conditionally load ``AVPlayer`` only when visible
- [627ea4d](https://github.com/thevickypedia/Filebrowser-iOS/commit/627ea4d79dcade46029895c70e9a409d3b429276) chore: Update release notes for v1.12.4

v1.12.4 (08/05/2025)
--------------------
- [e4c757b](https://github.com/thevickypedia/Filebrowser-iOS/commit/e4c757be4b0b6953d2ee3744ad8e27188396cbd7) chore: Release ``v1.12.4``
- [9bbe3d1](https://github.com/thevickypedia/Filebrowser-iOS/commit/9bbe3d15f244bb0624aa3abbb87f303b42d98537) perf: Lazy-load the ``AVPlayer`` asynchronously
- [342f644](https://github.com/thevickypedia/Filebrowser-iOS/commit/342f64418a43bf0d1bcd9f92582ba093113c6bd4) perf: Ensure that when ``currentIndex`` updates to a new file SwiftUI sees it as a new view state
- [2a181ad](https://github.com/thevickypedia/Filebrowser-iOS/commit/2a181adb035da996d41a14d038430cee0a1a0869) chore: Update release notes for v1.12.3

v1.12.3 (08/05/2025)
--------------------
- [2876c36](https://github.com/thevickypedia/Filebrowser-iOS/commit/2876c36626a3ed088535e60bb36e8c5d11957b22) chore: Release ``v1.12.3``
- [a09cf4d](https://github.com/thevickypedia/Filebrowser-iOS/commit/a09cf4d3a7f32f2b18cff7a8d7b0b4d84d37a6bb) perf: Fetch user account and user permissions in the background
- [403f48d](https://github.com/thevickypedia/Filebrowser-iOS/commit/403f48df6eafe0c708e0e670e2be47e064ed3e59) chore: Update release notes for v1.12.2

v1.12.2 (08/05/2025)
--------------------
- [69eb728](https://github.com/thevickypedia/Filebrowser-iOS/commit/69eb728a19d85606e514fc3c03a21a1166d9f8cd) chore: Release ``v1.12.2``
- [00db44a](https://github.com/thevickypedia/Filebrowser-iOS/commit/00db44aecac61a21c2aa2dcd0631b7b215c73c7e) perf: Store and retrieve cache data in the background with an async process
- [02ecc03](https://github.com/thevickypedia/Filebrowser-iOS/commit/02ecc03179786f9594287041d9e18d882936c266) fix: Memory leak - stop on cleanup media player `onDisappear`
- [c7b0924](https://github.com/thevickypedia/Filebrowser-iOS/commit/c7b0924cb6bb4f248954a040d71b9c11ed083f7c) perf: Replace `onChange` + `onAppear` combo with `taskID` to check and reload content
- [243b135](https://github.com/thevickypedia/Filebrowser-iOS/commit/243b1359634404320b883c9c3da9d73359da3758) perf: Avoid sorting files every time the body recomputes
- [37af164](https://github.com/thevickypedia/Filebrowser-iOS/commit/37af164c5762aad653a2bd7bade058e3a4c667bf) chore: Update release notes for v1.12.1

v1.12.1 (08/05/2025)
--------------------
- [67a1fca](https://github.com/thevickypedia/Filebrowser-iOS/commit/67a1fca1fc8f2922a41dfb08b729b30834e40235) chore: Release ``v1.12.1``
- [f091a9d](https://github.com/thevickypedia/Filebrowser-iOS/commit/f091a9dad099985d7dd05cce8dafa0fbd18b4744) refactor: Store login information in ``AppStorage``
- [1dbf5dc](https://github.com/thevickypedia/Filebrowser-iOS/commit/1dbf5dc3b9c96f01f58191501f04b94b78bfd508) ci: Create a controller workflow for individual tasks
- [9e37dad](https://github.com/thevickypedia/Filebrowser-iOS/commit/9e37dad0b3e71d77ce9707e68d09fbbe88b38142) chore: Update release notes for v1.12.0

v1.12.0 (08/04/2025)
--------------------
- [6ec574a](https://github.com/thevickypedia/Filebrowser-iOS/commit/6ec574a48835527631e06068ee29d33bfa734c7c) chore: Release ``v1.12.0``
- [7509d52](https://github.com/thevickypedia/Filebrowser-iOS/commit/7509d52fd164d33fc2d3f986bd1139e901db79f4) perf: Set default GIF animation to false
- [2c509d6](https://github.com/thevickypedia/Filebrowser-iOS/commit/2c509d693e17b7dda110dad8bc3fba5e2d8070cb) style: Move transit protection out of advanced settings in login UI
- [994d21d](https://github.com/thevickypedia/Filebrowser-iOS/commit/994d21d3336d074c6e34ef2bca7357d071ce7aa0) chore: Update release notes for v1.11.0

v1.11.0 (08/04/2025)
--------------------
- [5a00297](https://github.com/thevickypedia/Filebrowser-iOS/commit/5a002973cd1eaa539e88c80a1811e3fe0953970e) chore: Release ``v1.11.0``
- [365aa0e](https://github.com/thevickypedia/Filebrowser-iOS/commit/365aa0e9e2af97e9e20bcbaf0294f633fe4dc9cc) refactor: Setup dependencies in GHA workflow
- [57e0f0a](https://github.com/thevickypedia/Filebrowser-iOS/commit/57e0f0aaa1fb849ed8edd01a724cc937e8bc463d) refactor: Restructure GH workflows
- [46e4519](https://github.com/thevickypedia/Filebrowser-iOS/commit/46e45196c7d3baa94e2e199e2aefc7a8ff74b179) ci: Create a new GHA workflow to run test
- [53b8954](https://github.com/thevickypedia/Filebrowser-iOS/commit/53b89547cb7c52563ab5049758ce7d27899959de) test: Run functional test with example
- [9563935](https://github.com/thevickypedia/Filebrowser-iOS/commit/9563935b30e577e050c57f12e2e87041656de424) fix: Build error due to trailing ``,``
- [e6f9f65](https://github.com/thevickypedia/Filebrowser-iOS/commit/e6f9f65f0baf0cae73438713861a6e86432d2805) ci: Update build workflow to run independently
- [23ad132](https://github.com/thevickypedia/Filebrowser-iOS/commit/23ad1325dad35894a97cf61d82155066288e4a89) fix: Avoid updating ``NavigationStack`` multiple times per frame
- [72697be](https://github.com/thevickypedia/Filebrowser-iOS/commit/72697bece646cb69be5620ff40d6cd0d273aac50) fix: Replace lexicographic sorting vs natural (human-friendly) sorting
- [4a749c2](https://github.com/thevickypedia/Filebrowser-iOS/commit/4a749c27f94fab1d415c2d275f601c3111b63f7f) perf: Reduce code redundancies for file metadata and extension types
- [9e7ffec](https://github.com/thevickypedia/Filebrowser-iOS/commit/9e7ffec025d4c9ecc8a8e3f5a236746bb8192374) feat: Allow users to control caching and other advanced settings
- [88c095c](https://github.com/thevickypedia/Filebrowser-iOS/commit/88c095cc097a8440f3d50e744dbb6b95136b3139) perf: Asynchronously decode GIF thumbnails off the main thread
- [20701e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/20701e0e41c1efe36e4986f6ca2a26b4c3608bbf) chore: Update release notes for v1.10.0

v1.10.0 (08/03/2025)
--------------------
- [6401c11](https://github.com/thevickypedia/Filebrowser-iOS/commit/6401c11faa75a55d4becc9dacf2c51a2fcd3e3f2) chore: Release ``v1.10.0``
- [b4c221e](https://github.com/thevickypedia/Filebrowser-iOS/commit/b4c221ea8570e839a104b87bf3eef070cf071cd0) ci: Break GHA into multiple re-usable workflows
- [32ba26d](https://github.com/thevickypedia/Filebrowser-iOS/commit/32ba26d4318269ed19b6f21580d4ab18fe2b3bb7) feat: Include caching for text files
- [b7ad349](https://github.com/thevickypedia/Filebrowser-iOS/commit/b7ad349f59e8aa6f72e29ebc26d21e4e3c7afaa8) fix: Avoid multiple path separators in API URLs
- [a33b13f](https://github.com/thevickypedia/Filebrowser-iOS/commit/a33b13f063ec07999a4f8accf8a7f874f6afcbc2) fix: Include a random UUID to force a fresh view rebuild
- [124757a](https://github.com/thevickypedia/Filebrowser-iOS/commit/124757a3f8dcd6719e334983c573bb2930b51579) refactor: Refactor remote thumbnail to include default thumb
- [51e8a17](https://github.com/thevickypedia/Filebrowser-iOS/commit/51e8a17b4ab63df986aabf4b75090933091944d8) fix: Restart animation for GIF thumbnails if view is remounted or updated
- [6e5bcf6](https://github.com/thevickypedia/Filebrowser-iOS/commit/6e5bcf650bbf14ad69e9897d010ab4f757fe0687) fix: Replace URL encoding with a custom path sanitizer for cache keys
- [c484cd0](https://github.com/thevickypedia/Filebrowser-iOS/commit/c484cd01c6189caf8185c3db08ed6a5e955ceb66) fix: Set dedicated ``fileID``s for images and thumbnails
- [6f89cf1](https://github.com/thevickypedia/Filebrowser-iOS/commit/6f89cf1d3f642fc4d699563c85954cdcbec60a6f) refactor: Avoid logging true path with auth token
- [36912a3](https://github.com/thevickypedia/Filebrowser-iOS/commit/36912a36dfb8c22b2360e3e62860e33f99d28fd9) perf: Access results `FileListView` once and re-use during page load
- [b74b13b](https://github.com/thevickypedia/Filebrowser-iOS/commit/b74b13b54d7ee2510d4c54dbcfd88a420b0ae5a0) refactor: Include debug logs for cache storage and retrieval
- [73e6869](https://github.com/thevickypedia/Filebrowser-iOS/commit/73e6869edcc12383f6e596bc8f12b334e6bb3757) feat: Support GIF images in both ``FileDetailView`` and ``RemoteThumbnail``
- [d2eb54d](https://github.com/thevickypedia/Filebrowser-iOS/commit/d2eb54d41ef88babf1d73eea170db8498492f107) chore: Extend supported image and audio file extensions
- [8b79a67](https://github.com/thevickypedia/Filebrowser-iOS/commit/8b79a67932b5db693aababb761e74dbbf3502042) refactor: Reuse ``extensionTypes`` for ``systemIcon`` function
- [c95723a](https://github.com/thevickypedia/Filebrowser-iOS/commit/c95723a7638966800a64c73df8b6edac724970ac) rollback: View option for list vs grid types
- [8f15c26](https://github.com/thevickypedia/Filebrowser-iOS/commit/8f15c26587dc7180bf6a8629b225128716654b77) feat: Include a view option for list vs grid types
- [611e8d6](https://github.com/thevickypedia/Filebrowser-iOS/commit/611e8d69abeaf328a01fb53512efb267af23d71c) chore: Update release notes for v1.9.1

v1.9.1 (07/30/2025)
-------------------
- [5c5b573](https://github.com/thevickypedia/Filebrowser-iOS/commit/5c5b573ba861c7a234a188daab4b812201bc8364) chore: Release v1.9.1
- [fa1ac17](https://github.com/thevickypedia/Filebrowser-iOS/commit/fa1ac17136cfb354c1e272795beb421b44b4a367) style: Sort files and folders in dedicated groups
- [59b316d](https://github.com/thevickypedia/Filebrowser-iOS/commit/59b316dfb44854a01b7b9b366771cd530918aff8) feat: Include a sorting option in ``FileListView``
- [335efec](https://github.com/thevickypedia/Filebrowser-iOS/commit/335efec5ce89df4a31b17a986ca649891aac0726) chore: Update release notes for v1.9.0

v1.9.0 (07/30/2025)
-------------------
- [c90e479](https://github.com/thevickypedia/Filebrowser-iOS/commit/c90e479a23dc4267e2d013a7ad45ff5fc1031d56) chore: Release v1.9.0
- [3f82dc2](https://github.com/thevickypedia/Filebrowser-iOS/commit/3f82dc26f2e8b430b9aaa706d17bf83412db1778) style: Extend ``systemIcon`` to include more common file types
- [1b706c0](https://github.com/thevickypedia/Filebrowser-iOS/commit/1b706c05cee0414255e88b90e2828344fd654069) style: Add preview icons with content overlay in place of generic thumbnail
- [7e425d3](https://github.com/thevickypedia/Filebrowser-iOS/commit/7e425d361912095ddc946496c9a0d8ed291aaf98) perf: Pass callback reference to periodically update file cache size
- [833454d](https://github.com/thevickypedia/Filebrowser-iOS/commit/833454dbc85d786b415775f1f8a2bc90dd878c33) fix: Avoid creating a new ``AVPlayer`` on each render
- [9346d2d](https://github.com/thevickypedia/Filebrowser-iOS/commit/9346d2d5ad62d695ef9309224675599ae427cdcc) refactor: Remove unused references and rename misaligned
- [3e5255c](https://github.com/thevickypedia/Filebrowser-iOS/commit/3e5255c24bd167a11794b5beed167ccd2c2fd908) feat: Implement a fully reusable type agnostic caching mechanism
- [c855fbf](https://github.com/thevickypedia/Filebrowser-iOS/commit/c855fbf2fc78e19e0501321c7c2ab2af0e040e7c) feat: Add a button to clear disk cache
- [a9b97f1](https://github.com/thevickypedia/Filebrowser-iOS/commit/a9b97f1ca89326a25f3e70f9767296d62abcf4ca) chore: Update release notes for v1.8.0

v1.8.0 (07/29/2025)
-------------------
- [2596486](https://github.com/thevickypedia/Filebrowser-iOS/commit/2596486da32c3c298a2c3aebb0942ce45b8d4d0e) chore: Release v1.8.0
- [7f6df50](https://github.com/thevickypedia/Filebrowser-iOS/commit/7f6df50436ebd54cba76e1320317f4c80a449ea3) feat: Display client storage for thumbnails
- [3d98071](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d98071833c2e060b89f4fd2f37d60a8e2d5d5db) chore: Update release notes for v1.7.1

v1.7.1 (07/29/2025)
-------------------
- [14fe77d](https://github.com/thevickypedia/Filebrowser-iOS/commit/14fe77d27a38b9eebc54525da95476985499be6e) chore: Release v1.7.1
- [b462321](https://github.com/thevickypedia/Filebrowser-iOS/commit/b4623218c5777d36941d45c11cf716b4b9047b46) style: Re-organize settings view and rename server capacity
- [7ef08a7](https://github.com/thevickypedia/Filebrowser-iOS/commit/7ef08a733dbf70cc5a76a88cf5ed1197f8f68706) chore: Update release notes for v1.7.0

v1.7.0 (07/29/2025)
-------------------
- [603f95b](https://github.com/thevickypedia/Filebrowser-iOS/commit/603f95b1340019a93f046596ba135d762001c425) chore: Release v1.7.0
- [802efa8](https://github.com/thevickypedia/Filebrowser-iOS/commit/802efa8c4835786ef7013635bf675a24981ec955) feat: Display server storage in settings view
- [d350c19](https://github.com/thevickypedia/Filebrowser-iOS/commit/d350c1949690f81b9c5e73ab09ae7d6050787fe4) refactor: Create utils module for shared functionalities
- [69f25fa](https://github.com/thevickypedia/Filebrowser-iOS/commit/69f25fa978a3a955fb718e715834bc54336f5008) chore: Update release notes for v1.6.2

v1.6.2 (07/29/2025)
-------------------
- [e319771](https://github.com/thevickypedia/Filebrowser-iOS/commit/e31977140f8a75595eeed8644110a16056a5346f) chore: Release v1.6.2
- [fd726c3](https://github.com/thevickypedia/Filebrowser-iOS/commit/fd726c341e5e9a3a741de664d7c9194e2a75a5c7) fix: Re-mount ``RemoteThumbnail`` to avoid stale cache
- [0648f9f](https://github.com/thevickypedia/Filebrowser-iOS/commit/0648f9f66a3c1de33d758279a9b0052ad6c2cb33) perf: Invalidate cache when file is modified
- [1d5a423](https://github.com/thevickypedia/Filebrowser-iOS/commit/1d5a42331732477e18f6793d2abd58645b68101c) chore: Update release notes for v1.6.1

v1.6.1 (07/29/2025)
-------------------
- [065cb03](https://github.com/thevickypedia/Filebrowser-iOS/commit/065cb03c537cdc687c1e4e2fd483bd8e843db08b) chore: Release v1.6.1
- [9275575](https://github.com/thevickypedia/Filebrowser-iOS/commit/927557558fe452322d6a5c342ca6382850a32eb2) ci: Run iOS build when xcodeproj directory is updated
- [ea402eb](https://github.com/thevickypedia/Filebrowser-iOS/commit/ea402ebd4b95e99907758f3ec0867ccf4a9380fc) perf: add memory and disk caching for faster thumbnail view
- [b1ac4a6](https://github.com/thevickypedia/Filebrowser-iOS/commit/b1ac4a645c581026dcb323f722c2f517a958ebbf) chore: Update release notes for v1.6.0

v1.6.0 (07/29/2025)
-------------------
- [4fd42a3](https://github.com/thevickypedia/Filebrowser-iOS/commit/4fd42a34a612380a7045670935423ded63972bdb) chore: Release v1.6.0
- [e4d68cb](https://github.com/thevickypedia/Filebrowser-iOS/commit/e4d68cbae6618354f727bf18f5cba785740a5e83) fix: Unexpected ',' separator in x86 GHA runner
- [d20b915](https://github.com/thevickypedia/Filebrowser-iOS/commit/d20b9154369746bbb89cf199a53cd8af53f19186) build: Exclude arm64 for simulator builds
- [25fb066](https://github.com/thevickypedia/Filebrowser-iOS/commit/25fb066ba19bef8e096e45fc4cf96ee1ac4379dc) ci: Allow iOS build via manual trigger
- [ca97d53](https://github.com/thevickypedia/Filebrowser-iOS/commit/ca97d538b353b410bbe0aaeede2b6f262d525f79) feat: Add a new feature to load image thumbnails in FileListView

v1.5.0 (07/28/2025)
-------------------
- [e2007a8](https://github.com/thevickypedia/Filebrowser-iOS/commit/e2007a84f8f1eae290ae5f7245af057c857763d7) chore: Release v1.5.0
- [0ae1fa5](https://github.com/thevickypedia/Filebrowser-iOS/commit/0ae1fa54dd40f673fcb60d21408fd5d7c83a4196) refactor: Wrap all extension types in a single struct
- [032a6cf](https://github.com/thevickypedia/Filebrowser-iOS/commit/032a6cf88bf20d59380df132c140864823bcc045) feat: Allow navigation to next/previous files
- [9f1e8e6](https://github.com/thevickypedia/Filebrowser-iOS/commit/9f1e8e6a05e01d37053cac889e347e42a9c54add) feat: Include an option to cancel upload during mid-chunk
- [b9cd503](https://github.com/thevickypedia/Filebrowser-iOS/commit/b9cd5038a89bea856f11b44257edb6d0b63c482e) feat: Update upload functionality to support multiple files
- [9c265ae](https://github.com/thevickypedia/Filebrowser-iOS/commit/9c265ae357449a7dbd2b775a902d77479c11386c) chore: Update release notes for v1.4.1

v1.4.1 (07/27/2025)
-------------------
- [ad812a0](https://github.com/thevickypedia/Filebrowser-iOS/commit/ad812a00f804468042287b303c83ad6404805661) chore: Release v1.4.1
- [6c8d032](https://github.com/thevickypedia/Filebrowser-iOS/commit/6c8d0325a3ffc2e00a7d75cb907848d6a0fef33d) fix: Ensure file uploads are in current directory instead of root
- [28e8512](https://github.com/thevickypedia/Filebrowser-iOS/commit/28e8512ada1082bb97d1bbe988613daa23eac64f) chore: Update release notes for v1.4.0

v1.4.0 (07/27/2025)
-------------------
- [17c124e](https://github.com/thevickypedia/Filebrowser-iOS/commit/17c124e01b4475771eb43b8353d51ce7f94cec14) chore: Release v1.4.0
- [542a750](https://github.com/thevickypedia/Filebrowser-iOS/commit/542a75027889fb53d68bc5483e2f4911994a5043) feat: Includes an option to upload files to the server
- [cbfe134](https://github.com/thevickypedia/Filebrowser-iOS/commit/cbfe134dc3afbff21e1056b1ccbc19bcc856a5b1) chore: Update release notes for v1.3.1

v1.3.1 (07/27/2025)
-------------------
- [badae1f](https://github.com/thevickypedia/Filebrowser-iOS/commit/badae1fc7c8d7ad7f198128674545635a25bcfb3) chore: Release v1.3.1
- [f6afec8](https://github.com/thevickypedia/Filebrowser-iOS/commit/f6afec8a3927fad81f91abe36e8218134b354676) fix: Remove ambiguous server version on login screen
- [d8b96c5](https://github.com/thevickypedia/Filebrowser-iOS/commit/d8b96c55d5e2b757714f522581802bb6e62a9738) feat: Add theme manager toggle button to login page
- [8c3af7d](https://github.com/thevickypedia/Filebrowser-iOS/commit/8c3af7d30637aceefa961f28571a7dd4869513b5) chore: Update release notes for v1.3.0

v1.3.0 (07/27/2025)
-------------------
- [ae9733b](https://github.com/thevickypedia/Filebrowser-iOS/commit/ae9733b281d2afe66970212e805e2d95d481e10b) chore: Release v1.3.0
- [01ed580](https://github.com/thevickypedia/Filebrowser-iOS/commit/01ed5800bd0faf0203de8e86c0561788c3462d98) ci: Update release notes format to markdown
- [6acd0f0](https://github.com/thevickypedia/Filebrowser-iOS/commit/6acd0f009aee2c744a17a7b08d5381c3b5c5233d) fix: Remove unsupported video formats
- [3d4af43](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d4af4305a7add85b0ca618b56cb010935cb707f) fix: Include a missing fetch call for file metadata
- [2014e28](https://github.com/thevickypedia/Filebrowser-iOS/commit/2014e28e60d81ea2ffae1dc47bde5ca611032cb7) fix: Add a helper function to format file size in info tab
- [dcdfb7a](https://github.com/thevickypedia/Filebrowser-iOS/commit/dcdfb7aec7333b422ba86118d087bbad54d80818) fix: Use dateFormatExact flag to display file modified info
- [c019a64](https://github.com/thevickypedia/Filebrowser-iOS/commit/c019a644093327b919d3ca95ba424305b22290bc) feat: Include an option to set exact date format via settings
- [f1ca457](https://github.com/thevickypedia/Filebrowser-iOS/commit/f1ca457211248eadab79e3ab3d17c87fb5131481) chore: Update release notes for v1.2.1

v1.2.1 (07/26/2025)
-------------------
- [44ae4ce](https://github.com/thevickypedia/Filebrowser-iOS/commit/44ae4ce) chore: Release v1.2.1
- [1730d06](https://github.com/thevickypedia/Filebrowser-iOS/commit/1730d06) ci: Reinstate GitHub workflows for build and release
- [dd3675b](https://github.com/thevickypedia/Filebrowser-iOS/commit/dd3675b) refactor: Increase code reusability and log error response from the server
- [15c91d6](https://github.com/thevickypedia/Filebrowser-iOS/commit/15c91d6) chore: Update release notes for v1.2.0

v1.2.0 (07/25/2025)
-------------------
- [732540c](https://github.com/thevickypedia/Filebrowser-iOS/commit/732540c) chore: Release v1.2.0
- [e76e55b](https://github.com/thevickypedia/Filebrowser-iOS/commit/e76e55b) feat: New settings icon to toggle hide dotfiles option

v1.1.0 (07/25/2025)
-------------------
- [7f670aa](https://github.com/thevickypedia/Filebrowser-iOS/commit/7f670aa) chore: Release v1.1.0
- [5209ddf](https://github.com/thevickypedia/Filebrowser-iOS/commit/5209ddf) ci: Merge release notes to build workflow and add a custom commit message
- [2e5816a](https://github.com/thevickypedia/Filebrowser-iOS/commit/2e5816a) feat: Add a feature to rename files/folders with selection
- [cbaeb18](https://github.com/thevickypedia/Filebrowser-iOS/commit/cbaeb18) feat: Add a button to select/deselect all
- [1b25d48](https://github.com/thevickypedia/Filebrowser-iOS/commit/1b25d48) style: Include the app title on top of logo
- [e8fb636](https://github.com/thevickypedia/Filebrowser-iOS/commit/e8fb636) style: Position logout button on far right
- [c4d537a](https://github.com/thevickypedia/Filebrowser-iOS/commit/c4d537a) feat: Add a feature to select and delete files/folders
- [3da9da0](https://github.com/thevickypedia/Filebrowser-iOS/commit/3da9da0) feat: Add a new feature to create directories
- [215e7ec](https://github.com/thevickypedia/Filebrowser-iOS/commit/215e7ec) chore: Update release notes for v1.0.1

v1.0.1 (07/24/2025)
-------------------
- [63ef787](https://github.com/thevickypedia/Filebrowser-iOS/commit/63ef787) chore: Release v1.0.1
- [c0e2e18](https://github.com/thevickypedia/Filebrowser-iOS/commit/c0e2e18) ci: Update GHA to pull release notes since previous tag and create new tag & release
- [ce31a82](https://github.com/thevickypedia/Filebrowser-iOS/commit/ce31a82) fix: NavigationRequestObserver trying to update multiple times per frame
- [3db694a](https://github.com/thevickypedia/Filebrowser-iOS/commit/3db694a) fix: Inconsistent navigation title in sub-directories
- [eea3f7e](https://github.com/thevickypedia/Filebrowser-iOS/commit/eea3f7e) docs: Update documentation
- [c074b1a](https://github.com/thevickypedia/Filebrowser-iOS/commit/c074b1a) ci: Update GHA to make authenticated requests
- [38f6243](https://github.com/thevickypedia/Filebrowser-iOS/commit/38f6243) ci: Extend build GHA to automatically create a release
- [cf2726d](https://github.com/thevickypedia/Filebrowser-iOS/commit/cf2726d) chore: Make footer notes in login page hyperlinks
- [612a853](https://github.com/thevickypedia/Filebrowser-iOS/commit/612a853) chore: Add project information at the footer of login page
- [7f8ec83](https://github.com/thevickypedia/Filebrowser-iOS/commit/7f8ec83) ci: Add a new GHA workflow to build and print project version
- [867ab99](https://github.com/thevickypedia/Filebrowser-iOS/commit/867ab99) feat: Add appicon and login page logo
- [a8a71d8](https://github.com/thevickypedia/Filebrowser-iOS/commit/a8a71d8) chore: Update release notes for v1.0.0

v1.0.0 (07/23/2025)
-------------------
- [578284b](https://github.com/thevickypedia/Filebrowser-iOS/commit/578284b) ci: Add a new GH workflow to auto-update release notes
- [6b1241d](https://github.com/thevickypedia/Filebrowser-iOS/commit/6b1241d) fix: Reset navigation title when home button is pressed
- [d0bc98a](https://github.com/thevickypedia/Filebrowser-iOS/commit/d0bc98a) feat: Add the ability for home button to navigate to root directory
- [737a572](https://github.com/thevickypedia/Filebrowser-iOS/commit/737a572) fix: Handle different timestamp formats from the server
- [b6072cf](https://github.com/thevickypedia/Filebrowser-iOS/commit/b6072cf) feat: Add a feature to create new files and remove create button from detail page
- [c195fe1](https://github.com/thevickypedia/Filebrowser-iOS/commit/c195fe1) chore: Replace accent colors for buttons with static blue
- [e7ffc0d](https://github.com/thevickypedia/Filebrowser-iOS/commit/e7ffc0d) feat: Display a progress window in the UI while downloading
- [d52e91c](https://github.com/thevickypedia/Filebrowser-iOS/commit/d52e91c) feat: Onboard a custom logging framework
- [8963ef2](https://github.com/thevickypedia/Filebrowser-iOS/commit/8963ef2) fix: Inconsistencies in pop up menu for extra options
- [2fcccf9](https://github.com/thevickypedia/Filebrowser-iOS/commit/2fcccf9) fix: Fix redundant downloads and lazy previews
- [84fe8b6](https://github.com/thevickypedia/Filebrowser-iOS/commit/84fe8b6) revert: Rollback helper function (from: ad2ab32) for complex URL encoding
- [98717c7](https://github.com/thevickypedia/Filebrowser-iOS/commit/98717c7) feat: Add a custom drop down for special permissions
- [c03c18c](https://github.com/thevickypedia/Filebrowser-iOS/commit/c03c18c) docs: Add todo notes in the form of internal reminders
- [610394f](https://github.com/thevickypedia/Filebrowser-iOS/commit/610394f) feat: Display delete and rename buttons based on user's permission level
- [a2764c1](https://github.com/thevickypedia/Filebrowser-iOS/commit/a2764c1) feat: Add modified timestamp as time ago
- [13b16e1](https://github.com/thevickypedia/Filebrowser-iOS/commit/13b16e1) feat: Use FileItem object as backup for file metadata
- [ad2ab32](https://github.com/thevickypedia/Filebrowser-iOS/commit/ad2ab32) refactor: Create a helper function for URL encoding
- [84b0286](https://github.com/thevickypedia/Filebrowser-iOS/commit/84b0286) refactor: Unify conditions for media extensions
- [06bc5a8](https://github.com/thevickypedia/Filebrowser-iOS/commit/06bc5a8) fix: Avoid waiting for .content before showing a video/audio view
- [f50c3c2](https://github.com/thevickypedia/Filebrowser-iOS/commit/f50c3c2) style: Make dark/light mode button float on-screen
- [e55133b](https://github.com/thevickypedia/Filebrowser-iOS/commit/e55133b) feat: Add light/dark mode option
- [9d993e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/9d993e0) refactor: Unify media player and remove redundant code for audio/video
- [2d07ea5](https://github.com/thevickypedia/Filebrowser-iOS/commit/2d07ea5) fix: Strip / from server URLs when processing user input
- [0da1178](https://github.com/thevickypedia/Filebrowser-iOS/commit/0da1178) feat: Add support for streaming audio files
- [dcb0c3c](https://github.com/thevickypedia/Filebrowser-iOS/commit/dcb0c3c) feat: Add support for streaming video files
- [df773a1](https://github.com/thevickypedia/Filebrowser-iOS/commit/df773a1) feat: Add a new toggle button for transit protection
- [f597b85](https://github.com/thevickypedia/Filebrowser-iOS/commit/f597b85) style: Replace text buttons with material-icon-style shorthand
- [6516beb](https://github.com/thevickypedia/Filebrowser-iOS/commit/6516beb) feat: Add home and refresh buttons
- [c0ac1c8](https://github.com/thevickypedia/Filebrowser-iOS/commit/c0ac1c8) fix: Include a safety net to avoid URL malform for rename function
- [8391113](https://github.com/thevickypedia/Filebrowser-iOS/commit/8391113) feat: Add functionalities to get info, rename and delete files
- [888407b](https://github.com/thevickypedia/Filebrowser-iOS/commit/888407b) feat: Add support for PDF files
- [104006d](https://github.com/thevickypedia/Filebrowser-iOS/commit/104006d) perf: Use preview endpoint for faster response and less bandwidth
- [6c872ac](https://github.com/thevickypedia/Filebrowser-iOS/commit/6c872ac) feat: Add more text and image formats as supported types
- [f197024](https://github.com/thevickypedia/Filebrowser-iOS/commit/f197024) refactor: Simplify conditions for file extension check
- [4864359](https://github.com/thevickypedia/Filebrowser-iOS/commit/4864359) feat: Open images and text files in Simulator
- [292725b](https://github.com/thevickypedia/Filebrowser-iOS/commit/292725b) fix: Make login and logout messages disappearing
- [3b392c8](https://github.com/thevickypedia/Filebrowser-iOS/commit/3b392c8) feat: Add a 'remember me' toggle to keep/clear credentials
- [65390aa](https://github.com/thevickypedia/Filebrowser-iOS/commit/65390aa) feat: Add a logout button in simulator
- [bf12ba4](https://github.com/thevickypedia/Filebrowser-iOS/commit/bf12ba4) chore: Update .gitignore
- [6546e9e](https://github.com/thevickypedia/Filebrowser-iOS/commit/6546e9e) fix: Fix nested directory's navigation issue and previous buttons
- [55fe716](https://github.com/thevickypedia/Filebrowser-iOS/commit/55fe716) chore: Remove .DS_Store
- [069b05a](https://github.com/thevickypedia/Filebrowser-iOS/commit/069b05a) fix: Avoid printing item list in the login page in simulator
- [ad3e964](https://github.com/thevickypedia/Filebrowser-iOS/commit/ad3e964) fix: Remove stacking back buttons in the simulator
- [1033c20](https://github.com/thevickypedia/Filebrowser-iOS/commit/1033c20) feat: Navigate within dirs and sub-dirs
- [1c7d8a6](https://github.com/thevickypedia/Filebrowser-iOS/commit/1c7d8a6) feat: Distinguish files and folders in the simulator
- [a68e9a9](https://github.com/thevickypedia/Filebrowser-iOS/commit/a68e9a9) feat: Add a listing screen after successful auth
- [4a1f4d5](https://github.com/thevickypedia/Filebrowser-iOS/commit/4a1f4d5) feat: Create an auth manager to store JWT securely
- [356b4c2](https://github.com/thevickypedia/Filebrowser-iOS/commit/356b4c2) fix: Fix JWT parsing and print the token on screen
- [422f088](https://github.com/thevickypedia/Filebrowser-iOS/commit/422f088) feat: Process API login and display response
- [bcdd71f](https://github.com/thevickypedia/Filebrowser-iOS/commit/bcdd71f) Add login screen, username and password input fields
- [301c7f0](https://github.com/thevickypedia/Filebrowser-iOS/commit/301c7f0) refactor: Restructure code base
- [864e955](https://github.com/thevickypedia/Filebrowser-iOS/commit/864e955) feat: Setup a base hello world project
- [35266fa](https://github.com/thevickypedia/Filebrowser-iOS/commit/35266fa) Initial commit
