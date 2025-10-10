Release Notes
=============

v1.55.0 (10/10/2025)
--------------------
- [2e9d057](https://github.com/thevickypedia/Filebrowser-iOS/commit/2e9d0576fb3d7cf3c82129f1627c537ee7bd4487) chore: Release ``v1.55.0``
- [1b89f73](https://github.com/thevickypedia/Filebrowser-iOS/commit/1b89f737e296b893bdfc80877720dd9b22d006ce) feat: Avoid exit when a single upload fails with a status message at the end
- [8fb73bb](https://github.com/thevickypedia/Filebrowser-iOS/commit/8fb73bbc2e724a5f0662e12bea25b357bb7442ab) chore: Update release notes for v1.54.5

v1.54.5 (10/10/2025)
--------------------
- [b5f1cad](https://github.com/thevickypedia/Filebrowser-iOS/commit/b5f1cada86ec6913e867c0be36b8b3edc8b9315f) chore: Release ``v1.54.5``
- [4895b3d](https://github.com/thevickypedia/Filebrowser-iOS/commit/4895b3d7e3ddc2facc103f2bf8cdc1a1325fa8bb) perf: Improve download progress store without an explicit struct
- [eca0494](https://github.com/thevickypedia/Filebrowser-iOS/commit/eca0494b72de05ea6355ffc7cae2c978b7cfef0b) perf: Replace loop for download status with ``switch`` and ``reduce``
- [b677e8d](https://github.com/thevickypedia/Filebrowser-iOS/commit/b677e8d017be28534ff34f4e34f9ae801738f545) fix: Download state not being rendered properly when paused/resumed
- [977ce9e](https://github.com/thevickypedia/Filebrowser-iOS/commit/977ce9e64c5a67a3a91de5cb1418c1cdbf1543b8) feat: Extend avoid exit during failed downloads even when paused/resumed
- [7a85d9a](https://github.com/thevickypedia/Filebrowser-iOS/commit/7a85d9a41bbbd3e2b921f12b6583fa47a94e398e) feat: Avoid exit when a single download fails with a status message at the end
- [32b9c77](https://github.com/thevickypedia/Filebrowser-iOS/commit/32b9c77e75f8e3194f2562f7cf5fa82ef15b7fcb) chore: Update release notes for v1.54.4

v1.54.4 (10/05/2025)
--------------------
- [5f6e8fc](https://github.com/thevickypedia/Filebrowser-iOS/commit/5f6e8fc6fca88e6d42ba137c27cf789a469d50aa) chore: Release ``v1.54.4``
- [5c8d6ca](https://github.com/thevickypedia/Filebrowser-iOS/commit/5c8d6ca66c3af8849a4850d5bfbc54206f8e5c8f) perf: Include a server health check before resuming upload
- [34bbcad](https://github.com/thevickypedia/Filebrowser-iOS/commit/34bbcad61487bdaa64d479bd3d2d7d98264cb440) feat: Pause upload when network error
- [70eafa2](https://github.com/thevickypedia/Filebrowser-iOS/commit/70eafa2dbbb88accac9ddfe8d3f3a1b585d5ad77) chore: Update release notes for v1.54.3

v1.54.3 (10/05/2025)
--------------------
- [5d38671](https://github.com/thevickypedia/Filebrowser-iOS/commit/5d38671679d62b38b01e3b625003f14d147d9a91) chore: Release ``v1.54.3``
- [24557dd](https://github.com/thevickypedia/Filebrowser-iOS/commit/24557dd664645eb3c42c4f21e524a3e9a8347dcf) perf: Add a server health check before resuming download
- [7bc542b](https://github.com/thevickypedia/Filebrowser-iOS/commit/7bc542b4773ee2cba784183417c74373a002269c) feat: Automatically pause downloads during a network disconnection
- [06eb076](https://github.com/thevickypedia/Filebrowser-iOS/commit/06eb07632c65930898395a8036437d1cf03af260) fix: Reset credentials when disabling faceID to avoid invalid faceID toggle
- [cb9f7b8](https://github.com/thevickypedia/Filebrowser-iOS/commit/cb9f7b8d8c21de87a713ba2b7a8db6e29bd3ee4d) refactor: Move search request timeout options to constants
- [3b088a2](https://github.com/thevickypedia/Filebrowser-iOS/commit/3b088a200af6599d76703ce352447266e43edf57) fix: Avoid storing password unconditionally in keychain during background login
- [a1d8c2f](https://github.com/thevickypedia/Filebrowser-iOS/commit/a1d8c2f81e3033c56552933478502826aa953b06) chore: Update release notes for v1.54.2

v1.54.2 (10/04/2025)
--------------------
- [1431e56](https://github.com/thevickypedia/Filebrowser-iOS/commit/1431e5687a3bb5822e2be1cef4f47310cd5b892e) chore: Release ``v1.54.2``
- [3e3d995](https://github.com/thevickypedia/Filebrowser-iOS/commit/3e3d99579518825f1163c21e6be5e64998ee4cfd) perf: Reuse ``baseRequest`` state through out the session
- [7482c0f](https://github.com/thevickypedia/Filebrowser-iOS/commit/7482c0fa7604f3f3b6072d23c0aceda01df574f2) fix: Navigation issue within directories from search results
- [5dfb283](https://github.com/thevickypedia/Filebrowser-iOS/commit/5dfb28393df9985628ba54bf8f303c8061bf300a) fix: Use custom timeout for search
- [cb76cd0](https://github.com/thevickypedia/Filebrowser-iOS/commit/cb76cd0192887e0f70d98ef7f85114b42c336a5d) refactor: Remove discardable requester and reduce code redundancy
- [de9dc0e](https://github.com/thevickypedia/Filebrowser-iOS/commit/de9dc0e9a8fd2fabdac88c04e5f6901c683c57b2) chore: Update release notes for v1.54.1

v1.54.1 (10/03/2025)
--------------------
- [e053e33](https://github.com/thevickypedia/Filebrowser-iOS/commit/e053e33dfdc494d34b5c1a990b940bbc3aeb18f6) chore: Release ``v1.54.1``
- [a0b72b8](https://github.com/thevickypedia/Filebrowser-iOS/commit/a0b72b89e541da658016de0ef889727cbf369fe2) refactor: Re-create timed requests handler with new architecture
- [f516651](https://github.com/thevickypedia/Filebrowser-iOS/commit/f5166510571edf801d57a483135886e97c4449f5) perf: Keep error message for failed request generic and common across all modules
- [30ddc7e](https://github.com/thevickypedia/Filebrowser-iOS/commit/30ddc7ee4bd19761bfa70696ef89784e3cccc681) chore: Update release notes for v1.54.0

v1.54.0 (10/03/2025)
--------------------
- [426e1fd](https://github.com/thevickypedia/Filebrowser-iOS/commit/426e1fd6e8fe094b25b2a6f5a1273c7a2a5e1a1c) chore: Release ``v1.54.0``
- [2a1a58b](https://github.com/thevickypedia/Filebrowser-iOS/commit/2a1a58b4126ca2fe03a623ff5d72dcd11819ab2a) lint: Make linter happy
- [7ebbec9](https://github.com/thevickypedia/Filebrowser-iOS/commit/7ebbec900d024a338f79344183db846f898d3b35) perf: Make all egress requests time bound with a custom request session
- [168427e](https://github.com/thevickypedia/Filebrowser-iOS/commit/168427ead2db7d78495d01f3f89a09d2d7d729dc) fix: Avoid being stuck in a login loop when health check fails
- [20b6fb3](https://github.com/thevickypedia/Filebrowser-iOS/commit/20b6fb37e67cfa08f817c1d6db0033a21b519365) refactor: Move ``backgroundLoginFrequency`` to constants
- [1cc10ca](https://github.com/thevickypedia/Filebrowser-iOS/commit/1cc10ca6e32e5f599b49423a917591a5540fc244) chore: Update app metadata for existing properties
- [eaa6e3f](https://github.com/thevickypedia/Filebrowser-iOS/commit/eaa6e3fdb6458b84389bbe91317d2df0e99612d6) chore: Update release notes for v1.53.4

v1.53.4 (10/02/2025)
--------------------
- [2c56553](https://github.com/thevickypedia/Filebrowser-iOS/commit/2c565534ef40403594e10342c80c74a848215640) chore: Release ``v1.53.4``
- [9af01ed](https://github.com/thevickypedia/Filebrowser-iOS/commit/9af01eddfacfc1d86f36056ee5ddb5215199f999) perf: Include status code in login response from the server and use a common util func to format ``httpResponse``
- [0d15388](https://github.com/thevickypedia/Filebrowser-iOS/commit/0d153883c374d833a06ad0665c861e56a56b3dac) fix: Avoid performing multiple health checks when biometric login fails with fallback
- [1f4b572](https://github.com/thevickypedia/Filebrowser-iOS/commit/1f4b572bf4128be1d0e757c7532a2e62606fea6a) chore: Update release notes for v1.53.3

v1.53.3 (10/02/2025)
--------------------
- [34ed4e4](https://github.com/thevickypedia/Filebrowser-iOS/commit/34ed4e4466da513b0d2cdb670e9fc70812e5b7b3) chore: Release ``v1.53.3``
- [f5a0a61](https://github.com/thevickypedia/Filebrowser-iOS/commit/f5a0a6174cba98629e33fb1ccf8a0aa43cf31516) style: Create a toggle to view full file path in share management view
- [d6bf5d0](https://github.com/thevickypedia/Filebrowser-iOS/commit/d6bf5d0e981b9faa9585cab5585c62100c794226) style: Set geometry percent for shared content list
- [9d88be8](https://github.com/thevickypedia/Filebrowser-iOS/commit/9d88be809db9110cb33afeea1dce37ec064becf5) perf: Remove code redundancies for selected path stack
- [c47b17e](https://github.com/thevickypedia/Filebrowser-iOS/commit/c47b17eef4747b407d0520aee09e5b60a1e29cd2) chore: Update release notes for v1.53.2

v1.53.2 (10/01/2025)
--------------------
- [8583632](https://github.com/thevickypedia/Filebrowser-iOS/commit/858363295e692926d903a8f1676401350f77df04) chore: Release ``v1.53.2``
- [e5c78bc](https://github.com/thevickypedia/Filebrowser-iOS/commit/e5c78bc8dc327be14621e01576be4e55d8bf7f00) style: Show full file path in share sheet view
- [f1fe441](https://github.com/thevickypedia/Filebrowser-iOS/commit/f1fe4414b97201c36e97e65a22df87defbe2f6c4) fix: Intermittent issues with sharing an item from list view
- [c2a3ed4](https://github.com/thevickypedia/Filebrowser-iOS/commit/c2a3ed4830d3a6bf34bd3e89a993923304b9d371) style: Change server health check toast message to primary color
- [6b63385](https://github.com/thevickypedia/Filebrowser-iOS/commit/6b6338530e259e591d87303331a177950cdadfc4) perf: Add a prefix limit for number of components returned as part of detecting time left from epoch
- [4367d09](https://github.com/thevickypedia/Filebrowser-iOS/commit/4367d09bb9fff98133fa17687135cead669e54f3) chore: Update release notes for v1.53.1

v1.53.1 (10/01/2025)
--------------------
- [b30519a](https://github.com/thevickypedia/Filebrowser-iOS/commit/b30519a547fd059cdea2da34b60597f9870fcfc7) chore: Release ``v1.53.1``
- [ebb5fda](https://github.com/thevickypedia/Filebrowser-iOS/commit/ebb5fdae81d65e0fffbff24e8876849b259ea7d2) perf: Introduce a helper function to pluralize time left from epoch
- [a5f7e9a](https://github.com/thevickypedia/Filebrowser-iOS/commit/a5f7e9adda1f34df2d8176c2145a02b328936dbc) perf: Update helper function to calculate time left to include years, months and weeks
- [cb4239c](https://github.com/thevickypedia/Filebrowser-iOS/commit/cb4239c12e95d6dd307c8dd6ac6a4ab98fe47a36) perf: Remove ``seconds`` as an option for sharing
- [27bb697](https://github.com/thevickypedia/Filebrowser-iOS/commit/27bb6979f02fbdb1b583ccc320eae3474bf938d6) feat: Add expire duration for each path in share management
- [42c3f96](https://github.com/thevickypedia/Filebrowser-iOS/commit/42c3f96d2f70351576951cc0dbe2a0d417cd2f53) chore: Update release notes for v1.53.0

v1.53.0 (10/01/2025)
--------------------
- [f3590fb](https://github.com/thevickypedia/Filebrowser-iOS/commit/f3590fb26dbe2453c06f3d815bec5c2d99d4585c) chore: Release ``v1.53.0``
- [d16e3c7](https://github.com/thevickypedia/Filebrowser-iOS/commit/d16e3c77df16b50cda218ec55419bb9ed2393a77) lint: Fix linting warnings for identifier name violations
- [b47d68f](https://github.com/thevickypedia/Filebrowser-iOS/commit/b47d68fa0d27b54981597191ffd7e277b4e517a4) feat: Integrate error alerts for failed API calls in share management view
- [f924ab3](https://github.com/thevickypedia/Filebrowser-iOS/commit/f924ab36cf0676def96bc267c78f62c9f92511ea) feat: Implement delete functionality for share management
- [a288b3a](https://github.com/thevickypedia/Filebrowser-iOS/commit/a288b3af742d2ee89e3d3c2640e37574eab97258) feat: Extend share management to get actual shared content URLs
- [8dab590](https://github.com/thevickypedia/Filebrowser-iOS/commit/8dab590ef9166d46a806a6a8695dd13934e7fe97) feat: Add swipe actions for share management to allow copy to clipboard
- [6afa311](https://github.com/thevickypedia/Filebrowser-iOS/commit/6afa3112f828af72a192601510358ef128f7df20) feat: Add a ``hello-world`` share management option in settings view
- [3d89bfd](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d89bfdaef7bb60c0d3bc0efe166b89f9fc61d59) chore: Update release notes for v1.52.4

v1.52.4 (10/01/2025)
--------------------
- [cdbb988](https://github.com/thevickypedia/Filebrowser-iOS/commit/cdbb98829bf08e52fa44c897b5d4605b7eb2338c) chore: Release ``v1.52.4``
- [519b25f](https://github.com/thevickypedia/Filebrowser-iOS/commit/519b25fe1e06406406c53c895f9026a496adae8f) refactor: Move auth controls in auth manager
- [366ee70](https://github.com/thevickypedia/Filebrowser-iOS/commit/366ee7007b5e1e841188964b6b670108f310cfa7) fix: Add toast message modifier for advanced server settings view
- [a310d22](https://github.com/thevickypedia/Filebrowser-iOS/commit/a310d22b36074ad1a757ea1ea8e2f5e89722d1e1) style: Move advanced server settings into it's own sheet inside the base settings view
- [78cd4b9](https://github.com/thevickypedia/Filebrowser-iOS/commit/78cd4b950990628a91022d81f7bf330a3f9895f4) chore: Update release notes for v1.52.3

v1.52.3 (10/01/2025)
--------------------
- [30ecdec](https://github.com/thevickypedia/Filebrowser-iOS/commit/30ecdec21b0790ed32cc6e323eef5b3839acc64b) chore: Release ``v1.52.3``
- [3961ff4](https://github.com/thevickypedia/Filebrowser-iOS/commit/3961ff4acd8aa360020fa3ac90c2fe5601e84877) feat: Include a server health check before any type of login attempt
- [eeef1a0](https://github.com/thevickypedia/Filebrowser-iOS/commit/eeef1a0e9365351e11415865465356045e4e3005) refactor: Change default color for toast message to match accent
- [d74faf5](https://github.com/thevickypedia/Filebrowser-iOS/commit/d74faf517a5260a72903572721d0d2c363c0cb2a) refactor: Re-use toast message in ``ContentView`` instead of a one off state object
- [d62ff27](https://github.com/thevickypedia/Filebrowser-iOS/commit/d62ff27d19318426cab0966c573468abab4b0b06) chore: Update release notes for v1.52.2

v1.52.2 (09/30/2025)
--------------------
- [d6603ef](https://github.com/thevickypedia/Filebrowser-iOS/commit/d6603ef1c22c673c20719261e22470664c81929e) chore: Release ``v1.52.2``
- [e373eb5](https://github.com/thevickypedia/Filebrowser-iOS/commit/e373eb5407423bbfe388cc9aa717f2e4c3578294) revert: Center align all server information in settings view
- [e912a39](https://github.com/thevickypedia/Filebrowser-iOS/commit/e912a398c355ba8ac5cca5247b635d122a98c19d) style: Center align all server information in settings view
- [8f721d3](https://github.com/thevickypedia/Filebrowser-iOS/commit/8f721d3659d8007ebb388925d0608bc253df7f2e) fix: Stop re-auth timer when logged out
- [2cd057c](https://github.com/thevickypedia/Filebrowser-iOS/commit/2cd057c6c3efa48ad8e4623d98f95d411c241527) refactor: Move buffer time for repeat background login to constants
- [5d690f8](https://github.com/thevickypedia/Filebrowser-iOS/commit/5d690f81cc2354d7056f56c3d94b3ddb31674fff) feat: Display background login response as a toast message
- [d7749b6](https://github.com/thevickypedia/Filebrowser-iOS/commit/d7749b622e1443b5c2385cfb0ecc142788dcde2a) perf: Store password in auth environment object and re-use that for background login
- [87702e7](https://github.com/thevickypedia/Filebrowser-iOS/commit/87702e79d2382d89d8f822a90f432b2f23642f08) feat: Include a manual control to renew authentication in settings view
- [7bb768c](https://github.com/thevickypedia/Filebrowser-iOS/commit/7bb768ccb3b7e864e156e04fcf0c84e8e1338f11) chore: Update release notes for v1.52.1

v1.52.1 (09/30/2025)
--------------------
- [7f295df](https://github.com/thevickypedia/Filebrowser-iOS/commit/7f295dfe008713354be2763ca76cfe48a0fb3bde) chore: Release ``v1.52.1``
- [33281de](https://github.com/thevickypedia/Filebrowser-iOS/commit/33281decdea2b9c7f14682dedc582ba56f18d45d) refactor: Move background login to a struct of it's own
- [4f3249a](https://github.com/thevickypedia/Filebrowser-iOS/commit/4f3249ac6e27e104e5ca9e03ad85b16e8c921811) perf: Renew auth token 30s before it's expiry
- [825adc3](https://github.com/thevickypedia/Filebrowser-iOS/commit/825adc3e8f2187f0d928186cd6fba72427a4242e) chore: Update release notes for v1.52.0

v1.52.0 (09/29/2025)
--------------------
- [d2f0136](https://github.com/thevickypedia/Filebrowser-iOS/commit/d2f0136a9cfae0891503eb8e16031bb4a5359fda) chore: Release ``v1.52.0``
- [983f6fa](https://github.com/thevickypedia/Filebrowser-iOS/commit/983f6fa0ef0af5976d43ae7b62b2f4fab96ec4f1) perf: Repeat re-authentication only when session is near expiry
- [383fa26](https://github.com/thevickypedia/Filebrowser-iOS/commit/383fa266bc2df76c63f7eb2f972ffc753abbc993) perf: Run re-authentication every 5s only after 2h - when session expires
- [2001e71](https://github.com/thevickypedia/Filebrowser-iOS/commit/2001e7127b926acd157499ab346658360e601c6b) feat: Automatically re-authenticate with a repeat timer in the background
- [dfd7fab](https://github.com/thevickypedia/Filebrowser-iOS/commit/dfd7fab55a162ee987bb3f5f74a41c727ef4b24b) chore: Update release notes for v1.51.4

v1.51.4 (09/29/2025)
--------------------
- [ba5782f](https://github.com/thevickypedia/Filebrowser-iOS/commit/ba5782fc1776399f995dbadbabf7ee92237d1657) chore: Release ``v1.51.4``
- [ecf8ba7](https://github.com/thevickypedia/Filebrowser-iOS/commit/ecf8ba7261ad4938d8a4ec70e7c41675adee3f16) style: Ensure only one ``DisclosureGroup`` is expanded at a time in ``AdvancedSettingsView``
- [d326513](https://github.com/thevickypedia/Filebrowser-iOS/commit/d326513a090b749153a67530806bd288c1506f32) style: Break ``advancedSettings`` and ``loggingSettings`` into individual disclosure groups
- [2c496c4](https://github.com/thevickypedia/Filebrowser-iOS/commit/2c496c4f6467b5c727f3f4b801bc57ce2711c4d1) style: Update datetime format for boot time in device metrics
- [8b5051b](https://github.com/thevickypedia/Filebrowser-iOS/commit/8b5051b211c3b9573eb3c864ed61052c02cf47ec) refactor: Move all timezone controls to a single constant
- [be0e76d](https://github.com/thevickypedia/Filebrowser-iOS/commit/be0e76d09b85014ad52f74d8513046b7896f9c2b) chore: Update release notes for v1.51.3

v1.51.3 (09/29/2025)
--------------------
- [64ba526](https://github.com/thevickypedia/Filebrowser-iOS/commit/64ba5269d19f501f89eaf0ff517adcb4265d7b2b) chore: Release ``v1.51.3``
- [ae8375e](https://github.com/thevickypedia/Filebrowser-iOS/commit/ae8375ed027a45cebc13e56d61a01abc1bd4bc2a) perf: Avoid fetching system uptime repeatedly when metric is in view
- [e25c75e](https://github.com/thevickypedia/Filebrowser-iOS/commit/e25c75e06c49c9be8453f27c71e23aa230a26174) feat: Include boot/up time in device metrics and optimize utils code
- [b365240](https://github.com/thevickypedia/Filebrowser-iOS/commit/b36524091fcd291567f88ab3c24b083c15318be8) refactor: Replace tuple for usage metrics with generic struct
- [7d87184](https://github.com/thevickypedia/Filebrowser-iOS/commit/7d87184bbb4192b70d2900a47f491a8cb06427df) refactor: Move device metrics' structs to individual modules
- [942c19b](https://github.com/thevickypedia/Filebrowser-iOS/commit/942c19be533922f79b2bba2cf8f2b108392c9418) chore: Update release notes for v1.51.2

v1.51.2 (09/29/2025)
--------------------
- [169a99a](https://github.com/thevickypedia/Filebrowser-iOS/commit/169a99a797c8122d726050d1df959bba901309e7) chore: Release ``v1.51.2``
- [78362bb](https://github.com/thevickypedia/Filebrowser-iOS/commit/78362bb935745a4d066262c12210391d332d7bb5) perf: When pulse is set to ``never`` disable line chart for device metrics
- [ea5a18a](https://github.com/thevickypedia/Filebrowser-iOS/commit/ea5a18a68938338947a397796d46c6166eb6acff) perf: Reset history used for line chart in device metrics
- [f56689e](https://github.com/thevickypedia/Filebrowser-iOS/commit/f56689e12ce828aec5a041156bd4f83910340ac5) style: Add labels with system images for sandbox files and device metrics
- [447d92c](https://github.com/thevickypedia/Filebrowser-iOS/commit/447d92cb39edf527ccbb4c037df4ae55c05177a2) refactor: Movie hard coded variables for line chart to constants
- [c46bfc7](https://github.com/thevickypedia/Filebrowser-iOS/commit/c46bfc77b053fadc9a6f82de24c58967b19ddad5) style: Include usage percent on the left side of grid layout for device metrics
- [52b8108](https://github.com/thevickypedia/Filebrowser-iOS/commit/52b8108f348c320a7df73ccfba5cb4e5984669d2) style: Create a grid layout for line chart view for device metrics
- [2f12ff8](https://github.com/thevickypedia/Filebrowser-iOS/commit/2f12ff8865f27f70044143f230468dae76eaef7f) style: Display text on line chart view as a caption for device metrics
- [1ec8eae](https://github.com/thevickypedia/Filebrowser-iOS/commit/1ec8eae6f41bdc15e402eef3c8b62690f915d438) style: Include usage percent along with the title in live view for device metrics
- [ba3edd3](https://github.com/thevickypedia/Filebrowser-iOS/commit/ba3edd3df1d6563a5cd4f316ee80604528f1ae0d) style: Make live view a selectable option along side pie, bar, and stacked views
- [304ebc3](https://github.com/thevickypedia/Filebrowser-iOS/commit/304ebc34328c8bb8543f9c7d50c6f5959be5bd36) style: Make CPU history appear similar to macOS' activity monitor
- [0966ee6](https://github.com/thevickypedia/Filebrowser-iOS/commit/0966ee64b0c554961873d34fffd900ca9d48f127) feat: Include an ECG like pulse view for CPU metrics
- [6235ff1](https://github.com/thevickypedia/Filebrowser-iOS/commit/6235ff15bf8783c520de1a1d82505028d6328b71) refactor: Move hard coded variables to constants module
- [03d41f8](https://github.com/thevickypedia/Filebrowser-iOS/commit/03d41f817cd5ce6715a6d7e5d7b0610a9c494c40) chore: Update release notes for v1.51.1

v1.51.1 (09/28/2025)
--------------------
- [deae701](https://github.com/thevickypedia/Filebrowser-iOS/commit/deae70155f5c26f06e1a64f81e5317927dad115c) chore: Release ``v1.51.1``
- [7102c3e](https://github.com/thevickypedia/Filebrowser-iOS/commit/7102c3e41d77b7a8ea526f03beb261a6871473bf) refactor: Separate ``showOnlyLogFiles`` toggle from file list to clarify empty states in sandbox view
- [28e9400](https://github.com/thevickypedia/Filebrowser-iOS/commit/28e94009d403797c4bfe28a5039a80f6ba1ce2cd) chore: Update release notes for v1.51.0

v1.51.0 (09/28/2025)
--------------------
- [35aaf4b](https://github.com/thevickypedia/Filebrowser-iOS/commit/35aaf4b2e5557404fb63e4aea1d8f9a2eb0389de) chore: Release ``v1.51.0``
- [1d774b4](https://github.com/thevickypedia/Filebrowser-iOS/commit/1d774b42351bdd8bcef86e8c6e0931a2fc451289) feat: Create new icon to reload sandbox files and move rollover logs button to local group
- [58f2952](https://github.com/thevickypedia/Filebrowser-iOS/commit/58f2952a7aa382006c4ca13c0675cf54d11d9170) feat: Create a tool bar button to manually rotate log files
- [3b17a22](https://github.com/thevickypedia/Filebrowser-iOS/commit/3b17a224bd1c94b13dc51579462fe1931938c108) perf: Auto create indexed log files based on number of lines
- [f1b4a98](https://github.com/thevickypedia/Filebrowser-iOS/commit/f1b4a98cd258e981bacbb319beef00ad8aff50a6) perf: Offload some repeated computation in log framework to init
- [bda8b41](https://github.com/thevickypedia/Filebrowser-iOS/commit/bda8b41c3cf81d4812b7e27db26677e12c305241) chore: Update release notes for v1.50.4

v1.50.4 (09/28/2025)
--------------------
- [5a713fe](https://github.com/thevickypedia/Filebrowser-iOS/commit/5a713fe276c4577c10ab855c306d860730aff9c8) chore: Release ``v1.50.4``
- [1e55625](https://github.com/thevickypedia/Filebrowser-iOS/commit/1e556253203ae877bdba54b3c2c90b0d7d807461) style: Avoid filenames in toast messages when processing response from file exporter
- [91b10ca](https://github.com/thevickypedia/Filebrowser-iOS/commit/91b10ca1f42b8c8a21aa8ae6712f4dda06e1957a) feat: Include ``activityType``, and ``activityError`` to track export response
- [01a8712](https://github.com/thevickypedia/Filebrowser-iOS/commit/01a871296efcf5f6af108f44363431b629dc54a5) refactor: Create a reusable function to process response from ``FileExporter``
- [e3cc073](https://github.com/thevickypedia/Filebrowser-iOS/commit/e3cc0735cd45c85ce24352162a95a6169ec06d03) feat: Extend success/cancel handler for file exporter to local file container and file detail view
- [4c35a9f](https://github.com/thevickypedia/Filebrowser-iOS/commit/4c35a9f56ac3cb8967969506a10b705b1994dd09) feat: Include a success/cancel handler for file exporter
- [ad828aa](https://github.com/thevickypedia/Filebrowser-iOS/commit/ad828aaa83bc90ce56f267bfe299e885869e2dd1) feat: Add error and toast message function to device metrics' export
- [0490a78](https://github.com/thevickypedia/Filebrowser-iOS/commit/0490a780e550612f767426de478f8c499680d0ab) refactor: Restructure code for better readability and fix error titles in list view
- [51853a1](https://github.com/thevickypedia/Filebrowser-iOS/commit/51853a182ace112cb961f41fbaee91985cf847f9) chore: Update release notes for v1.50.3

v1.50.3 (09/28/2025)
--------------------
- [af62c4f](https://github.com/thevickypedia/Filebrowser-iOS/commit/af62c4f4816e98a3ede2973200f390188ef7766d) chore: Release ``v1.50.3``
- [2335849](https://github.com/thevickypedia/Filebrowser-iOS/commit/2335849853aa09578860c3209fcfaac094090be5) fix: Avoid repeated exports when metrics' export sheet is presented; Add a timestamp for filename
- [b4c430e](https://github.com/thevickypedia/Filebrowser-iOS/commit/b4c430e8b6a9e7cde497c13c7672c5b5ace611a2) style: Change icon arrangement and page width for metrics view
- [aebe5ed](https://github.com/thevickypedia/Filebrowser-iOS/commit/aebe5ed1fd11b5db62a5f12a9e50e5d7090a068e) feat: Add an option to export device metrics snapshot
- [805c5fb](https://github.com/thevickypedia/Filebrowser-iOS/commit/805c5fb3f0d125bda284e99c9130eab050683d15) chore: Update release notes for v1.50.2

v1.50.2 (09/28/2025)
--------------------
- [929989e](https://github.com/thevickypedia/Filebrowser-iOS/commit/929989e9dbd7db858079134494ac6157b9d5c60d) chore: Release ``v1.50.2``
- [51e63e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/51e63e0a7368149c56f0d1bafda8ddc0479ec08c) style: Add a last updated timestamp at the footer for device metrics
- [875dcee](https://github.com/thevickypedia/Filebrowser-iOS/commit/875dcee719e408d5de5bb9bb1f489a7460bc0c47) feat: Include a button for manual refresh in device metrics when ``pulse`` is set to never
- [4a7aae6](https://github.com/thevickypedia/Filebrowser-iOS/commit/4a7aae603a84e1642639cef240ddce3b6591074b) fix: Remove empty ``systemImage`` for unselected ``Pulse`` option in device metrics
- [3890151](https://github.com/thevickypedia/Filebrowser-iOS/commit/3890151a37a5ba3f293a487babcef52f83bbe4ef) feat: Add an option for ``pulse`` to control the refresh interval on device metrics
- [b419a6d](https://github.com/thevickypedia/Filebrowser-iOS/commit/b419a6da15d961e7941ea453fcb93a7caab31e37) chore: Update release notes for v1.50.1

v1.50.1 (09/28/2025)
--------------------
- [8a36199](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a36199683bd10c056815674c13e722a8b64ea50) chore: Release ``v1.50.1``
- [a459368](https://github.com/thevickypedia/Filebrowser-iOS/commit/a45936890ab6b67dc7bf07ac98f0e127fe0221c8) refactor: Persist the chosen metrics view style option
- [ebd4a45](https://github.com/thevickypedia/Filebrowser-iOS/commit/ebd4a4597909364d992f93189d89a612f3472ccf) style: Change naming convention for ``histogram`` to ``stacked``
- [0fb1857](https://github.com/thevickypedia/Filebrowser-iOS/commit/0fb18576f233f7a8c61157d12935bb812b3cf8dc) feat: Add selection options for metrics view like ``piechart``, ``bar`` and ``histogram``
- [f40de2e](https://github.com/thevickypedia/Filebrowser-iOS/commit/f40de2eee0fe1f5727c4a253aec3e18dc77d2ea2) chore: Update release notes for v1.50.0

v1.50.0 (09/27/2025)
--------------------
- [193055b](https://github.com/thevickypedia/Filebrowser-iOS/commit/193055b228d1c5cb01964f0a2df2538963207067) chore: Release ``v1.50.0``
- [f40857e](https://github.com/thevickypedia/Filebrowser-iOS/commit/f40857e2282302b8d39fef5b69d4cc97479b24f6) fix: Fix label name for device metrics
- [59a62d8](https://github.com/thevickypedia/Filebrowser-iOS/commit/59a62d8d9ea5408e7ac0865a349f6493a53062fe) style: Update styling for device metrics
- [eded3ba](https://github.com/thevickypedia/Filebrowser-iOS/commit/eded3baf9ba672c13fadea60883918b4dfe38065) feat: Include disk and CPU metrics as pie charts
- [07c60e6](https://github.com/thevickypedia/Filebrowser-iOS/commit/07c60e6b996f1afff0b96665856ca3fa7725e86f) style: Show memory usage as a pie chart with .5s as refresh interval
- [4551005](https://github.com/thevickypedia/Filebrowser-iOS/commit/45510053ee7862ab22add52dd228f1dc0d18d75e) feat: Include a new view to show memory usage
- [8632deb](https://github.com/thevickypedia/Filebrowser-iOS/commit/8632debcf1be1c9e99de367dae503181e0ffff93) refactor: Remove background TUS uploader
- [a18fb25](https://github.com/thevickypedia/Filebrowser-iOS/commit/a18fb255757fcf420d876f66a477488d650feac0) refactor: Move preview file size limit to constants
- [d2b0eac](https://github.com/thevickypedia/Filebrowser-iOS/commit/d2b0eacff7e46d60ae1a91774551bf9c5c569760) style: Ping modify sheet's ``VStack`` to top
- [6f5f658](https://github.com/thevickypedia/Filebrowser-iOS/commit/6f5f658c4823e92b8baa1edadb74e74dfd8e6630) chore: Update release notes for v1.49.4

v1.49.4 (09/27/2025)
--------------------
- [844ba8a](https://github.com/thevickypedia/Filebrowser-iOS/commit/844ba8aac113043a247d7019c33cfed7432fe440) chore: Release ``v1.49.4``
- [f2d5ff4](https://github.com/thevickypedia/Filebrowser-iOS/commit/f2d5ff4aeb7120acc105a5d53e12749514bfa7ea) style: Update preview error style to match sandbox view
- [ecbbaa7](https://github.com/thevickypedia/Filebrowser-iOS/commit/ecbbaa755aaff8194e8620d9fe65e4b062cd0ced) feat: Check for unsafe file preview limit in sandbox file viewer
- [70ff181](https://github.com/thevickypedia/Filebrowser-iOS/commit/70ff181f5cf3fcbf2830e857a872ce3d1ecd995c) refactor: Remove unwanted local arguments
- [b57cb20](https://github.com/thevickypedia/Filebrowser-iOS/commit/b57cb20cd88c964d674e5818446dc9eadf0fb041) refactor: Load file preview in detail view only if its within preview size limit
- [7a70ca3](https://github.com/thevickypedia/Filebrowser-iOS/commit/7a70ca368a27418b184ffab98cdd8b24242e4aa9) refactor: Create dedicated module for UI alerts
- [c99c93a](https://github.com/thevickypedia/Filebrowser-iOS/commit/c99c93a9178edce634a51c26f596cb840c7a04e3) refactor: Differentiate preview error vs error alert
- [a18cf1b](https://github.com/thevickypedia/Filebrowser-iOS/commit/a18cf1be4754ea2585ef9353be59afe0d4126ddd) refactor: Cleanup unused code in detail view
- [da73056](https://github.com/thevickypedia/Filebrowser-iOS/commit/da73056df72fd5d1805cde55290289888f7ead21) chore: Update release notes for v1.49.3

v1.49.3 (09/27/2025)
--------------------
- [41630f4](https://github.com/thevickypedia/Filebrowser-iOS/commit/41630f45d766a92f95316f45a8971dd807c0e3a0) chore: Release ``v1.49.3``
- [e9ccd2f](https://github.com/thevickypedia/Filebrowser-iOS/commit/e9ccd2fe9f4ce2a9f60ff9f0ddc332a25e1ae81b) refactor: Load local files' view asynchronously
- [cec8d48](https://github.com/thevickypedia/Filebrowser-iOS/commit/cec8d481e7610eb0c0d2bdd714c98079d5464a70) refactor: Simplify local files' view and keep it similar to file detail view
- [cda3015](https://github.com/thevickypedia/Filebrowser-iOS/commit/cda301541dcb78a72dee81c2b1ff1cd0dd8ca7dd) fix: Reset rename input and new resource name upon successful action
- [f84dcac](https://github.com/thevickypedia/Filebrowser-iOS/commit/f84dcacf999446f1b4f44d20530e833d49bc31e9) fix: Avoid sheet overlap between media resume prompt and file export
- [5cceab2](https://github.com/thevickypedia/Filebrowser-iOS/commit/5cceab204c7df732c61c3856ba453491c955ee97) refactor: Always show file export options when downloading files in detail view
- [f245ce7](https://github.com/thevickypedia/Filebrowser-iOS/commit/f245ce78a670be1a39b064f8160b595b3bec2c7b) revert: New drag to select feature
- [a5c1cb6](https://github.com/thevickypedia/Filebrowser-iOS/commit/a5c1cb6ede32635d8a4b706b98aad65fde17569b) style: Remove drag selection for list view
- [adea3d8](https://github.com/thevickypedia/Filebrowser-iOS/commit/adea3d87bb9c5fe28c3b409a70f2a029cafa529e) revert: Style update for drag selection
- [a98b6d3](https://github.com/thevickypedia/Filebrowser-iOS/commit/a98b6d32320513acb1186255472266cc792a005d) style: Update styling for drag selection
- [5883d7b](https://github.com/thevickypedia/Filebrowser-iOS/commit/5883d7b7f11f06b79de69c02341ec789bd70e78b) feat: Include a new drag to select feature
- [6d73862](https://github.com/thevickypedia/Filebrowser-iOS/commit/6d73862fab17efc774bb471909d362af422457c0) chore: Update release notes for v1.49.2

v1.49.2 (09/26/2025)
--------------------
- [10bac0d](https://github.com/thevickypedia/Filebrowser-iOS/commit/10bac0d3d83ea669dc37c1381b60e290870eb7a1) chore: Release ``v1.49.2``
- [4a7b9ff](https://github.com/thevickypedia/Filebrowser-iOS/commit/4a7b9ff057d7e9a1455665b4c7860e62b944a0c6) feat: Distinguish uploading vs pending state in uploading view
- [2b43753](https://github.com/thevickypedia/Filebrowser-iOS/commit/2b4375395f427ac0940aedf6f2f9be219b1ecc50) fix: Index count mismatch for upload queue and restore next up functionality
- [18b1e3b](https://github.com/thevickypedia/Filebrowser-iOS/commit/18b1e3bbea81b8e464583f417adae9c1f8089688) chore: Update release notes for v1.49.1

v1.49.1 (09/25/2025)
--------------------
- [8380c0a](https://github.com/thevickypedia/Filebrowser-iOS/commit/8380c0ad42de89c0828a90ae27b46a971703325e) chore: Release ``v1.49.1``
- [1f4881d](https://github.com/thevickypedia/Filebrowser-iOS/commit/1f4881d19a5b43ac7be70ba8d2a17fcb5e4e48d0) feat: Include an option to export local files
- [613f920](https://github.com/thevickypedia/Filebrowser-iOS/commit/613f92067eb9b72ea85043a08c66d963052808f8) chore: Update release notes for v1.49.0

v1.49.0 (09/25/2025)
--------------------
- [e840143](https://github.com/thevickypedia/Filebrowser-iOS/commit/e840143f961667606ef336270120e3f4cb9715a7) chore: Release ``v1.49.0``
- [7bcb22b](https://github.com/thevickypedia/Filebrowser-iOS/commit/7bcb22b9303fb1506e9dcba3337ac76c5602c6e1) revert: Replace unloading local files' list only when ``localFilesListView`` is closed
- [794c932](https://github.com/thevickypedia/Filebrowser-iOS/commit/794c9322ae7803a3820567b24b734e68dc973cfe) feat: Allow opening all text and PDF files via local files list view
- [f6419aa](https://github.com/thevickypedia/Filebrowser-iOS/commit/f6419aae75ed7d188efb4e83262257eaf8f57d24) fix: Load local files when files sheet appears, disappears or when log option is toggled
- [dc59078](https://github.com/thevickypedia/Filebrowser-iOS/commit/dc59078b7507831cdeb9746774800a6c97882d17) fix: Delete local files using the filename instead of its index
- [9ee4a8b](https://github.com/thevickypedia/Filebrowser-iOS/commit/9ee4a8b6d37062b0dbfa8eae854ae249115087d5) refactor: Rename all references to log files' views and structs
- [648005d](https://github.com/thevickypedia/Filebrowser-iOS/commit/648005db28e34b03ef783dd847664eceef344209) feat: Add a filter option to show non-log files
- [74c578e](https://github.com/thevickypedia/Filebrowser-iOS/commit/74c578efaf4774684d84bd2022a2f4318e7b2faf) style: Include error messages when failed to fetch/delete log files
- [4db22b8](https://github.com/thevickypedia/Filebrowser-iOS/commit/4db22b8d2d4e424c1323fff6d4ae6b9ebe1db531) perf: Add timestamp to media player progress saver and set to trace level
- [6c26d8e](https://github.com/thevickypedia/Filebrowser-iOS/commit/6c26d8e64dac8c90c1e41e5bfee27b2bf94c05d6) chore: Update release notes for v1.48.0

v1.48.0 (09/25/2025)
--------------------
- [67a3f55](https://github.com/thevickypedia/Filebrowser-iOS/commit/67a3f55dfbfe7e94e4332fb2de0036b05afb9ed9) chore: Release ``v1.48.0``
- [21f7e5e](https://github.com/thevickypedia/Filebrowser-iOS/commit/21f7e5e4cb1dc64c7548ef450bdb5ff9c3530855) perf: Create a dispatch work item to avoid piling up aync queue to set ``isSeeking`` flag
- [c0cb652](https://github.com/thevickypedia/Filebrowser-iOS/commit/c0cb6526d28080770866c39a912aa49fdfe67abc) fix: Avoid saving progress when seek is in progress for media player
- [a521a23](https://github.com/thevickypedia/Filebrowser-iOS/commit/a521a230a8b387423772a02aede719123eeb0ba8) feat: Check current play back time against media threshold to store progress upon player exit
- [923c707](https://github.com/thevickypedia/Filebrowser-iOS/commit/923c707a9151e206e13c6c6a5183bc038fdeb555) fix: Avoid media progress save condition becoming negative
- [c42a7e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/c42a7e0ca6cd4fc1f2883cb847c4a366ec91ea62) chore: Update release notes for v1.47.2

v1.47.2 (09/24/2025)
--------------------
- [c8f5821](https://github.com/thevickypedia/Filebrowser-iOS/commit/c8f582120f94c25cdf877a69decd761b2bb1a477) chore: Release ``v1.47.2``
- [0700e9f](https://github.com/thevickypedia/Filebrowser-iOS/commit/0700e9fbac0a927c6c929d7c99b51634c7dea44f) style: Disable search type buttons when search is in progress
- [b0063cd](https://github.com/thevickypedia/Filebrowser-iOS/commit/b0063cd44ca5a7f302f2dc44b31d075d8b08b4ac) style: Include emoji icon to indicate upload vs download in the resp progress bar
- [1787ff9](https://github.com/thevickypedia/Filebrowser-iOS/commit/1787ff9b28b2e21a2580c51b3d301252f1f39218) refactor: Merge download and upload attributes into one stack and simplify view render
- [aa6782d](https://github.com/thevickypedia/Filebrowser-iOS/commit/aa6782d486d0d2463d573900bd84fbb16a9b61f4) refactor: Re-use auth state, removing duplicate from list view
- [754804a](https://github.com/thevickypedia/Filebrowser-iOS/commit/754804a5b54a85c2ff527e905e78fbc8cf773640) chore: Update release notes for v1.47.1

v1.47.1 (09/24/2025)
--------------------
- [da000ef](https://github.com/thevickypedia/Filebrowser-iOS/commit/da000ef5550726d9c10edc7d582b7173e6f457e3) chore: Release ``v1.47.1``
- [8c35163](https://github.com/thevickypedia/Filebrowser-iOS/commit/8c35163184a0094b374ab5fb93aa83363e93abfa) refactor: Replace boiler plate code with enums and structured switch cases
- [d86e3a9](https://github.com/thevickypedia/Filebrowser-iOS/commit/d86e3a93f20bc122a12f3e19f2dbbc5180c01e03) ci: Install ``swiftlint`` only when unavailable
- [f3eefba](https://github.com/thevickypedia/Filebrowser-iOS/commit/f3eefbacf59562bd9457a6563f7dbb6ead230483) chore: Update release notes for v1.47.0

v1.47.0 (09/24/2025)
--------------------
- [578ebb3](https://github.com/thevickypedia/Filebrowser-iOS/commit/578ebb328a171514e26d987e0e1e4bffeef1b052) chore: Release ``v1.47.0``
- [9bbbe6d](https://github.com/thevickypedia/Filebrowser-iOS/commit/9bbbe6d9824f20597c9122b3326b8ecc7342fbf3) lint: Fix line breaks and case sentivity in enums
- [7505142](https://github.com/thevickypedia/Filebrowser-iOS/commit/75051426817567086158218a956eac466e0001e3) fix: Simply re-start the upload when resumed since ``PATCH`` includes ``upload-offset``
- [dc58e70](https://github.com/thevickypedia/Filebrowser-iOS/commit/dc58e703cebb9e5f0af0b512e795085124fe3cd9) feat: Implement pause-able uploads in list view
- [9279c64](https://github.com/thevickypedia/Filebrowser-iOS/commit/9279c6492716cb0e372c96501d5a6864ff7fd4e7) chore: Update release notes for v1.46.1

v1.46.1 (09/23/2025)
--------------------
- [f28fe25](https://github.com/thevickypedia/Filebrowser-iOS/commit/f28fe25ae286b448c36994d052b887be25a04749) chore: Release ``v1.46.1``
- [8ab87d0](https://github.com/thevickypedia/Filebrowser-iOS/commit/8ab87d0e85f5cced93dffb654ade535fa41d77e7) style: Update button sytle for pause/resume and cancel
- [1d0393b](https://github.com/thevickypedia/Filebrowser-iOS/commit/1d0393b7fc0a5dd4894418e982b536fec9cbe448) feat: Include notification and logging to indicate download state - paused/resumed/cancelled
- [b51a60a](https://github.com/thevickypedia/Filebrowser-iOS/commit/b51a60a86525201228dbc2cc2d770d9ea075658b) chore: Update release notes for v1.46.0

v1.46.0 (09/23/2025)
--------------------
- [ceb5a28](https://github.com/thevickypedia/Filebrowser-iOS/commit/ceb5a28d33922b8e2fa57166fa97f5167844bc05) chore: Release ``v1.46.0``
- [25c8390](https://github.com/thevickypedia/Filebrowser-iOS/commit/25c8390ad1c038d9074d2782353a0244af30c19b) fix: Add ``buttonStyle`` to address button overlap between ``pause`` and ``cancel``
- [a12c665](https://github.com/thevickypedia/Filebrowser-iOS/commit/a12c665a5088458cab27a029eca11841f24e1c3e) feat: Implement pause-able downloads in list view
- [83ebcc4](https://github.com/thevickypedia/Filebrowser-iOS/commit/83ebcc40b1e47e171d5729ce50f012877d718b2c) chore: Update release notes for v1.45.3

v1.45.3 (09/23/2025)
--------------------
- [d7df5ce](https://github.com/thevickypedia/Filebrowser-iOS/commit/d7df5cec6465ef38b3274ad4b9e1e8a9463754bb) chore: Release ``v1.45.3``
- [c62264d](https://github.com/thevickypedia/Filebrowser-iOS/commit/c62264d8f73f2d13d4950d24e3d1c0281176ef2e) style: Change word wrap option for text viewer to a button inside the parent stack
- [5eee054](https://github.com/thevickypedia/Filebrowser-iOS/commit/5eee0546566ae6a0bc3a54aaf620aa4cab6a87d8) style: Increase frame width for advanced settings view
- [91bedf5](https://github.com/thevickypedia/Filebrowser-iOS/commit/91bedf55d99156622908b1ef85f80947edfec597) perf: Instantiate logger during both appear and change of advanced settings view
- [ee133ee](https://github.com/thevickypedia/Filebrowser-iOS/commit/ee133ee0f2b9f90889d3732ec7c3186a35d3c236) chore: Update release notes for v1.45.2

v1.45.2 (09/23/2025)
--------------------
- [b903a08](https://github.com/thevickypedia/Filebrowser-iOS/commit/b903a087b9c3e7ad2412e194c9f5a045889c8d3a) chore: Release ``v1.45.2``
- [95d7b66](https://github.com/thevickypedia/Filebrowser-iOS/commit/95d7b664f684dfc2e1676170b6c75873ebffb1bf) feat: Create a dedicated log initalizer and control log configuration from advanced settings in login view
- [607f724](https://github.com/thevickypedia/Filebrowser-iOS/commit/607f72409ee2257529f861710461e5d39c7bcc55) perf: Remove rendering multiple ``View``s for log files and setup a navigation stack with a dedicated module
- [7dcff14](https://github.com/thevickypedia/Filebrowser-iOS/commit/7dcff14997b434323f7e80a4ad2471543a007ca7) perf: Create an async queue for logging to avoid wiring multiple logs simultaneously
- [ce44b75](https://github.com/thevickypedia/Filebrowser-iOS/commit/ce44b75258d5e479a5fd6b477d639d03762b4f84) fix: Text in log files overlap because of padding with ``UTF-8`` emojis
- [e8d978d](https://github.com/thevickypedia/Filebrowser-iOS/commit/e8d978d911cd7834588fb0d6843a27d5463c766d) chore: Update release notes for v1.45.1

v1.45.1 (09/23/2025)
--------------------
- [d21aac1](https://github.com/thevickypedia/Filebrowser-iOS/commit/d21aac124b2d7fdc45a77c8f5a723ac988901b90) chore: Release ``v1.45.1``
- [cf5e508](https://github.com/thevickypedia/Filebrowser-iOS/commit/cf5e508a93909e4217621d3e5d7bd3b4122988c4) feat: Include an option to delete log files
- [3a146c5](https://github.com/thevickypedia/Filebrowser-iOS/commit/3a146c51496f2040e4baf037354590baf7005105) feat: Add a new toggle button for word wrap in default text viewer
- [43ba0df](https://github.com/thevickypedia/Filebrowser-iOS/commit/43ba0df4bdc169293a45101fcf4e97e81fa2a1be) chore: Update release notes for v1.45.0

v1.45.0 (09/23/2025)
--------------------
- [6fcd094](https://github.com/thevickypedia/Filebrowser-iOS/commit/6fcd094a9b383893c7fe66f336c4f2ce4801b17b) chore: Release ``v1.45.0``
- [8240a13](https://github.com/thevickypedia/Filebrowser-iOS/commit/8240a1377868ac4f12a9b07d17955d13be7383c9) style: Open log files in default text extension viewer
- [921072a](https://github.com/thevickypedia/Filebrowser-iOS/commit/921072aa057700fd0a4e1a1d11246b84cb659f5a) style: Switch logs files' view to full screen sheet
- [77d1be0](https://github.com/thevickypedia/Filebrowser-iOS/commit/77d1be0ef4c0cfb6595bb3e4c0464772c892ed7e) feat: Create a new view within settings sheet to view log files
- [94508c7](https://github.com/thevickypedia/Filebrowser-iOS/commit/94508c745b7bd87342366dcc865f46a1affaf84f) refactor: Add datetime identifier for log files
- [3948f78](https://github.com/thevickypedia/Filebrowser-iOS/commit/3948f78cb50e879e0846c322d349fb1961243491) fix: Autoclosure for logging framework
- [8d84dd9](https://github.com/thevickypedia/Filebrowser-iOS/commit/8d84dd988398f191e814b878f1659463cb21ffc5) perf: Write logs to file in a dedicated thread with low priority
- [0d853c1](https://github.com/thevickypedia/Filebrowser-iOS/commit/0d853c12b8b13c4d2c2bee0f903eb03a188cd909) perf: Write file logs to file off the main thread
- [7fdad07](https://github.com/thevickypedia/Filebrowser-iOS/commit/7fdad07ba98a264f1a1e4294c0b5903d05b6e2b1) feat: Create an option to write logs to a file
- [81b34d5](https://github.com/thevickypedia/Filebrowser-iOS/commit/81b34d5442d6aedc64e5cbe693c39fe607c193d1) refactor: Disable autoplay for videos launched for the first time
- [02e3664](https://github.com/thevickypedia/Filebrowser-iOS/commit/02e3664041d5016cc9715c6f454a554af1c133bc) chore: Update release notes for v1.44.1

v1.44.1 (09/22/2025)
--------------------
- [7cc14e4](https://github.com/thevickypedia/Filebrowser-iOS/commit/7cc14e4ce238a4391cdb2b40a384987b799e0a3c) chore: Release ``v1.44.1``
- [3a427aa](https://github.com/thevickypedia/Filebrowser-iOS/commit/3a427aaf323f5a8553f0a309f23efada64b1d4b0) fix: Show upload progress only when progress begins
- [367e12c](https://github.com/thevickypedia/Filebrowser-iOS/commit/367e12c7abfe7242c5d40b1aa39fcc187913eb7a) refactor: Move download and upload views to dedicated modules and stacks
- [3dc2914](https://github.com/thevickypedia/Filebrowser-iOS/commit/3dc29148df72e2aeb1d20d3693950a033fb8b67e) chore: Update release notes for v1.44.0

v1.44.0 (09/21/2025)
--------------------
- [9d948e9](https://github.com/thevickypedia/Filebrowser-iOS/commit/9d948e9a35633eb4ffeae56d46ac9b721cff0bf8) chore: Release ``v1.44.0``
- [ede9884](https://github.com/thevickypedia/Filebrowser-iOS/commit/ede98842e0b9ae7402b02c2b0d17bb38b3e07851) feat: Include page numbers for PDF files
- [2de60e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/2de60e0e71fdf41a4a7b531f91a409017bf5e573) chore: Update release notes for v1.43.3

v1.43.3 (09/21/2025)
--------------------
- [736da52](https://github.com/thevickypedia/Filebrowser-iOS/commit/736da52c2482c30f73b63dc9b00a1faec6f71448) chore: Release ``v1.43.3``
- [c2ff48b](https://github.com/thevickypedia/Filebrowser-iOS/commit/c2ff48b6687fa707f0e56aba0c9bea89f745de65) fix: Remove nested duplicate for ``showSave`` condition
- [2f04ffb](https://github.com/thevickypedia/Filebrowser-iOS/commit/2f04ffb5274a36038cdb432cb90817e124433047) refactor: Unify file download functionalities from list and detail view
- [cd559f1](https://github.com/thevickypedia/Filebrowser-iOS/commit/cd559f111a0589cd8e8ab8ddc26d245088722f26) chore: Update release notes for v1.43.2

v1.43.2 (09/21/2025)
--------------------
- [af77c0e](https://github.com/thevickypedia/Filebrowser-iOS/commit/af77c0e07a1b8359e97006671f8e69fcfd90b152) chore: Release ``v1.43.2``
- [4fbd7a6](https://github.com/thevickypedia/Filebrowser-iOS/commit/4fbd7a620523e3d371c0548f322a07a5ec2cf273) fix: Stop preparing for upload when sheet is dismissed/swiped-down
- [58b3957](https://github.com/thevickypedia/Filebrowser-iOS/commit/58b39577d12a539fe81d00d38723a5599d6c97ee) chore: Update release notes for v1.43.1

v1.43.1 (09/21/2025)
--------------------
- [f221aa5](https://github.com/thevickypedia/Filebrowser-iOS/commit/f221aa5ec4c15f9ae186167e93b58235fdc78a56) chore: Release ``v1.43.1``
- [2fa03c4](https://github.com/thevickypedia/Filebrowser-iOS/commit/2fa03c4d8e38e65a27916c2c8020b07c3bdec36e) fix: Remove temp solution for non-sendable type ``NSItemProvider`` in ``PhotoPicker``
- [d9dcbc5](https://github.com/thevickypedia/Filebrowser-iOS/commit/d9dcbc513de1fff602cd963641a1767962ea1db9) chore: Update release notes for v1.43.0

v1.43.0 (09/21/2025)
--------------------
- [41471e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/41471e0916e8de42401b2e9d2c69d324ab7c83a4) chore: Release ``v1.43.0``
- [7b9610b](https://github.com/thevickypedia/Filebrowser-iOS/commit/7b9610b8a6bfca98cea864bc4d04e6074e7797c2) fix: Fix broken file uploads
- [ad45d2b](https://github.com/thevickypedia/Filebrowser-iOS/commit/ad45d2b0bc9a0929788f608f4492622ed5f70a16) refactor: Move cancelled status message to ``cancelUpload`` function
- [c911eb3](https://github.com/thevickypedia/Filebrowser-iOS/commit/c911eb3c87029648216850bf6345c46804896cb5) perf: Change ``photoPickerStatus`` attributes to ``Int`` type to avoid potential memory leaks
- [365bd89](https://github.com/thevickypedia/Filebrowser-iOS/commit/365bd8971c496326f404f1a672b07be6c3a203ef) perf: Remove unused ``processedFiles`` array
- [b0fd9e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/b0fd9e0c5d1058a47ebf08a46a17a895cbb8a704) style: Add clear status messages for upload confirmation
- [3763729](https://github.com/thevickypedia/Filebrowser-iOS/commit/3763729d96769341591d5f07fef11d95ebe79109) perf: Avoid fetching files after each file's upload completion
- [3b3d4b4](https://github.com/thevickypedia/Filebrowser-iOS/commit/3b3d4b4353dc847f1f908f5c99d4f61f86e1211d) perf: Reduce the delay to cleanup temp files after remote server upload
- [fdfac5d](https://github.com/thevickypedia/Filebrowser-iOS/commit/fdfac5d34395bd466074ca7d21effc8af486d68d) chore: Update release notes for v1.42.1

v1.42.1 (09/20/2025)
--------------------
- [c8c598e](https://github.com/thevickypedia/Filebrowser-iOS/commit/c8c598ef4cdadadec24020b50d928cd1bac6d438) chore: Release ``v1.42.1``
- [b2bcac6](https://github.com/thevickypedia/Filebrowser-iOS/commit/b2bcac6ba42ee64921c8eda234022a21c9f42572) refactor: Move ``ProcessedResult`` enum to top-level
- [d50e254](https://github.com/thevickypedia/Filebrowser-iOS/commit/d50e254125affc210bb123f6490bb8efe03683e0) lint: Fix character limit violation
- [20cbf2e](https://github.com/thevickypedia/Filebrowser-iOS/commit/20cbf2e95b334b8f479ddad192782118c21e0d5e) refactor: Move ``UploadState`` enum to top-level
- [4a04c26](https://github.com/thevickypedia/Filebrowser-iOS/commit/4a04c26457cdb06a9638eb93f218045623d753ec) refactor: Convert long tuple into a struct for download records
- [c4f0f9b](https://github.com/thevickypedia/Filebrowser-iOS/commit/c4f0f9b12bd29aa00a9adb6afbf1cb3ac3841254) perf: Reduce ``maxUploadStagingLimit``
- [613d2df](https://github.com/thevickypedia/Filebrowser-iOS/commit/613d2dfaa59e1e091f8be189a45fed13ac87546e) style: Display selected options' icon in list view only if a selection is made
- [f3ec0f1](https://github.com/thevickypedia/Filebrowser-iOS/commit/f3ec0f172b73d265eec359a9558aa960a6bd97f1) refactor: Replace redundant condition blocks with a closure
- [eac8c1b](https://github.com/thevickypedia/Filebrowser-iOS/commit/eac8c1b59341d417bba4d1c5ca9a76d29d5ab299) perf: Unify ``getFiles`` vs ``performFetch`` functionalities
- [70ea73f](https://github.com/thevickypedia/Filebrowser-iOS/commit/70ea73f91c39de17b636d5b631a158909fcc8b39) chore: Update release notes for v1.42.0

v1.42.0 (09/20/2025)
--------------------
- [e2bba5e](https://github.com/thevickypedia/Filebrowser-iOS/commit/e2bba5e1a5252051d8caeb85ac6ea1571b4fee40) chore: Release ``v1.42.0``
- [0502357](https://github.com/thevickypedia/Filebrowser-iOS/commit/0502357bf6748e5ee68de8112ed8734eb08604cc) refactor: Move hard-coded upload staging limit to ``Constants``
- [0068b23](https://github.com/thevickypedia/Filebrowser-iOS/commit/0068b2383bbdffb303789a3969a3ba4337bef9e1) perf: Set ``isPreparingUpload`` flag to ``false`` immediately after the first file is staged
- [c3c0360](https://github.com/thevickypedia/Filebrowser-iOS/commit/c3c0360cacd9830a480ce5f2f15e83f9c015f496) refactor: Reconstruct logging levels
- [1264048](https://github.com/thevickypedia/Filebrowser-iOS/commit/1264048fc981010ea7964d0a1a0600207140ddf2) perf: Processes photo selection results in batches of concurrent tasks to avoid memory and CPU overhead during large selections
- [ea95e98](https://github.com/thevickypedia/Filebrowser-iOS/commit/ea95e983bf1af5418e0d6739ebe44d75af6bc411) perf: Update last user server after each successful login
- [e5fc16c](https://github.com/thevickypedia/Filebrowser-iOS/commit/e5fc16c78bad3b9eb8115f0af35dbd5495cdcf57) chore: Update release notes for v1.41.1

v1.41.1 (09/19/2025)
--------------------
- [4df7043](https://github.com/thevickypedia/Filebrowser-iOS/commit/4df7043ca8a809f84d659c9f1817a9cc6834d3da) chore: Release ``v1.41.1``
- [fe17952](https://github.com/thevickypedia/Filebrowser-iOS/commit/fe179522f36211c1e07e0afc4f220a9864dd2520) perf: Include next up information when only 1 file is pending for upload
- [31df8c6](https://github.com/thevickypedia/Filebrowser-iOS/commit/31df8c6ae13537cc308d58c2378526404043ac29) refactor: Move ``PHPickerResult`` preProcessor to a standalone function
- [b5e2926](https://github.com/thevickypedia/Filebrowser-iOS/commit/b5e29265a1076fa1d9bc1dfaded85433c16c2b3a) chore: Update release notes for v1.41.0

v1.41.0 (09/19/2025)
--------------------
- [5dcdd6e](https://github.com/thevickypedia/Filebrowser-iOS/commit/5dcdd6e406eaec023f3b690835deec8ed01e19ca) chore: Release ``v1.41.0``
- [ca02518](https://github.com/thevickypedia/Filebrowser-iOS/commit/ca02518959f37868d20e16b7ad8561fda566a602) feat: Implement asynchronous task-based concurrency for photo picker with structured cancellation
- [fcda6a2](https://github.com/thevickypedia/Filebrowser-iOS/commit/fcda6a2658b487965c29f3d9a2c13b0a61b12660) chore: Update release notes for v1.40.2

v1.40.2 (09/19/2025)
--------------------
- [0132d98](https://github.com/thevickypedia/Filebrowser-iOS/commit/0132d9800f3d275fbd52afce4d9d46ed1b8d6135) chore: Release ``v1.40.2``
- [3ecc272](https://github.com/thevickypedia/Filebrowser-iOS/commit/3ecc272477486fcbe5a82218869cb7f46448d4d3) perf: Reset upload stats when file uploads finish
- [980c18c](https://github.com/thevickypedia/Filebrowser-iOS/commit/980c18ca63a86bf367658f7ea27dcbc4f0b8a099) perf: Add a ``processingFiles`` state to keep track of files being copied to temp
- [a543787](https://github.com/thevickypedia/Filebrowser-iOS/commit/a5437877f157b4441c9c897e212781f9328fe239) fix: Remove ``currentlyPreparing`` state since async initiates file copy in parallel
- [b4cc98f](https://github.com/thevickypedia/Filebrowser-iOS/commit/b4cc98f2400519107bf873a114323a06b8ffb56f) style: Update current upload index w.r.t uploading vs pending state
- [7356ea6](https://github.com/thevickypedia/Filebrowser-iOS/commit/7356ea61a77b3cc4199f7aae6c509c22b2e4f793) fix: Display correct upload index in ``uploadingStack``
- [3d665f0](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d665f0a99bedc8e3148f03afbb35db3b28893e3) perf: Preprocess photo picker results to avoid change in total selected count
- [f9c265a](https://github.com/thevickypedia/Filebrowser-iOS/commit/f9c265ab2c5e9574e94cb1e88257ee5b902a84d0) perf: Retain uploadingStack while files are still being prepared
- [268e813](https://github.com/thevickypedia/Filebrowser-iOS/commit/268e81335a6afbace133b047d47900825305a679) perf: Use dispatch group with concurrent queue to parallelize the writing to temp
- [36af17f](https://github.com/thevickypedia/Filebrowser-iOS/commit/36af17f94c53faab421dbaf7666c657b9ad316d3) perf: Disable auto-lock while file upload is in progress
- [04ebfcb](https://github.com/thevickypedia/Filebrowser-iOS/commit/04ebfcbde766e8d036b1fb3a5962961a9467cdbe) chore: Update release notes for v1.40.1

v1.40.1 (09/19/2025)
--------------------
- [78cbe40](https://github.com/thevickypedia/Filebrowser-iOS/commit/78cbe407c6dbf63f21002384fb8c625651e216eb) chore: Release ``v1.40.1``
- [6955b96](https://github.com/thevickypedia/Filebrowser-iOS/commit/6955b9673193cca02210cfd16134b156617ac36e) perf: Display upload files' names in the UX before extracting the data
- [804250a](https://github.com/thevickypedia/Filebrowser-iOS/commit/804250a513c6fe94ef196a7bcd33134d27f86275) perf: Remove temp file post upload with a 5s delay to avoid potential race condition
- [fe59974](https://github.com/thevickypedia/Filebrowser-iOS/commit/fe59974967fc6d3fc80ef34b0bdcbcc2ae479e5c) chore: Update release notes for v1.40.0

v1.40.0 (09/18/2025)
--------------------
- [63b02f7](https://github.com/thevickypedia/Filebrowser-iOS/commit/63b02f74b52a04cf688bdef4f0415b0025a10145) chore: Release ``v1.40.0``
- [c5dcf42](https://github.com/thevickypedia/Filebrowser-iOS/commit/c5dcf42f7ca11a62aac2ea69af63e00ddabba8c3) fix: Resolve inaccurate upload files' progress counter
- [2b7490c](https://github.com/thevickypedia/Filebrowser-iOS/commit/2b7490c159818985c8bd4b79d35613b8fcef567a) feat: Show current processing queue while upload begins
- [227bff2](https://github.com/thevickypedia/Filebrowser-iOS/commit/227bff29ffcdc26115c5880fa4551c74d842cc92) perf: Simplify retry handler for thumbnails
- [8a1a9bc](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a1a9bcb8f1ebd85b4b81736a46ad465288eea93) chore: Store ``thumbnailRetryLimit`` as a constant
- [f04a7e9](https://github.com/thevickypedia/Filebrowser-iOS/commit/f04a7e94d0fb84b6fb7ffc152f09357ba5b1d367) perf: Clear failed thumbnail paths when cache is cleared
- [8bed5e8](https://github.com/thevickypedia/Filebrowser-iOS/commit/8bed5e8f66eeba328746389c91f1b51f01a005da) perf: Add a retry logic for thumbnail loader
- [3f1e989](https://github.com/thevickypedia/Filebrowser-iOS/commit/3f1e989475fd6bc636f39cf20938e9c6a3ba7c7d) perf: Copy files to temp parallely but wait for completion before initating upload
- [a5b5132](https://github.com/thevickypedia/Filebrowser-iOS/commit/a5b5132c5f65338eac3cc71d9f4bb2ff189088c6) revert: Rollback full async photo/video upload process
- [40d7afa](https://github.com/thevickypedia/Filebrowser-iOS/commit/40d7afa933d26681eb961e188b942961b7660208) perf: Use fully concurrent file upload process
- [8475e68](https://github.com/thevickypedia/Filebrowser-iOS/commit/8475e68f36f9deaa1f5ed23431c3348dc0fe578a) perf: Copy upload files to temp directory instead of writing
- [ff69a6d](https://github.com/thevickypedia/Filebrowser-iOS/commit/ff69a6dc8723b96135ad03584d341dd5bdfb59c9) perf: Use dispatch group with concurrent queue to parallelize the writing to temp
- [ea9004f](https://github.com/thevickypedia/Filebrowser-iOS/commit/ea9004fb87afa5288091d037cf1be79473a1ddd9) perf: Start upload process immediately after the first file is ready while copying the rest asynchronously
- [b28faa9](https://github.com/thevickypedia/Filebrowser-iOS/commit/b28faa96d569b776cb63a3273cd80758ac3f3e40) feat: Start upload immediately after the first file is copied to temp using an yield-like approach
- [33d7c28](https://github.com/thevickypedia/Filebrowser-iOS/commit/33d7c285a74e89356eb0cbf6cdab8970a141bddc) fix: Remove redundant JWT decode step for biometrics sign in
- [b233381](https://github.com/thevickypedia/Filebrowser-iOS/commit/b233381e6512226061f2126919d3f8be34793035) revert: Rollback async copy to temp process for file uploads
- [d29542c](https://github.com/thevickypedia/Filebrowser-iOS/commit/d29542c30f9bcb5e2842abab5663c3905ff26910) feat: Start upload immediately after the first file is copied to temp while copying the rest to temp asynchronously
- [d8daaa2](https://github.com/thevickypedia/Filebrowser-iOS/commit/d8daaa2db86b2ab9c70ddcaf9e5065b0e4936e80) revert: Rollback the yield-like file uploader as it blocks the copy to temp action
- [7eebbf4](https://github.com/thevickypedia/Filebrowser-iOS/commit/7eebbf407935848c2f021c1d9454d7813e75ae58) feat: Start upload immediately after the first file is copied to temp using a yield-like approach
- [ae3212f](https://github.com/thevickypedia/Filebrowser-iOS/commit/ae3212faca88cd54c60b9fdf0db6adf54091b744) chore: Update release notes for v1.39.4

v1.39.4 (09/18/2025)
--------------------
- [823ee1f](https://github.com/thevickypedia/Filebrowser-iOS/commit/823ee1f38767f006cda3f3e0e18abd7879a11f77) chore: Release ``v1.39.4``
- [7b07fd3](https://github.com/thevickypedia/Filebrowser-iOS/commit/7b07fd335af0c9972661c511a3a1421938be7899) ci: Update working directory for ``Info.plist`` after refactor
- [5f5c2cb](https://github.com/thevickypedia/Filebrowser-iOS/commit/5f5c2cb098617f07ae2537d1baa45d5d1236d7b0) fix: Avoid exposing auth token when logging URL paths
- [bc1879e](https://github.com/thevickypedia/Filebrowser-iOS/commit/bc1879ead2c84f398809c9fcd67f6684a26c0fcd) refactor: Offload more standalone functions from ``FileListView``
- [932aa3f](https://github.com/thevickypedia/Filebrowser-iOS/commit/932aa3fe72a4c3bb9cf783f10357feb87505830f) refactor: Log more information for login failures
- [a0602fb](https://github.com/thevickypedia/Filebrowser-iOS/commit/a0602fb91d4e8b0fdefc0f816b330817e01741bb) fix: Make ``getNavigationTitle`` function non-private
- [c086e7a](https://github.com/thevickypedia/Filebrowser-iOS/commit/c086e7a4dab9603c2103f4ed524faf7981bfe8ac) refactor: Offload minor functionalities from ``FileListView`` to helper module
- [e392e49](https://github.com/thevickypedia/Filebrowser-iOS/commit/e392e49c45ecb4d2668acbf6e2f598494d806893) refactor: Group modules according to their functionalities
- [a4757d2](https://github.com/thevickypedia/Filebrowser-iOS/commit/a4757d29a739118d1bab9ddaa7cbfc22f4ead2b6) refactor: Use last knwon ``serverURL`` as default
- [b76c0db](https://github.com/thevickypedia/Filebrowser-iOS/commit/b76c0dbdc5dcc5c8596b361e0a9a748e854cc5dc) chore: Update release notes for v1.39.3

v1.39.3 (09/18/2025)
--------------------
- [62c258c](https://github.com/thevickypedia/Filebrowser-iOS/commit/62c258c1f4902b39d77c1db53e245f84954505e7) chore: Release ``v1.39.3``
- [985deb4](https://github.com/thevickypedia/Filebrowser-iOS/commit/985deb438d5a2cda187f740f0794e5fee85e36ae) fix: Remove deprecated bluetooth function for ``AVAudioSession``
- [9e12bfb](https://github.com/thevickypedia/Filebrowser-iOS/commit/9e12bfb874d483c069d4a420210c0eaea9bfd24e) refactor: Move ``thumbnailQuality`` to constants and convert all constants to ``let``
- [bb23ecb](https://github.com/thevickypedia/Filebrowser-iOS/commit/bb23ecb52102f00ba2bd27f0a632f2d3a777f7e6) perf: Implement thread safety for multi-file upload logic
- [273df72](https://github.com/thevickypedia/Filebrowser-iOS/commit/273df72b9be6f2487b0210b20615452442d34cfe) perf: Set caching logs to trace level
- [7a898b9](https://github.com/thevickypedia/Filebrowser-iOS/commit/7a898b9c4ab20857fa73b2cd3be8ab64436ff093) perf: Remove static prepare upload delay with accurate status for upload stack
- [ccc6d02](https://github.com/thevickypedia/Filebrowser-iOS/commit/ccc6d022a614e41ca1e0dd4969df53388f34b968) chore: Update release notes for v1.39.2

v1.39.2 (09/17/2025)
--------------------
- [6587ae4](https://github.com/thevickypedia/Filebrowser-iOS/commit/6587ae47fb7d0672d98c4dac5d14f69f8a9fccc0) chore: Release ``v1.39.2``
- [5a4a5f4](https://github.com/thevickypedia/Filebrowser-iOS/commit/5a4a5f4d99313ea1c6f6d16e1af67badc9bedc05) refactor: Move all hard-coded controls to ``Constants`` module
- [bcb1a00](https://github.com/thevickypedia/Filebrowser-iOS/commit/bcb1a006a18494aeef2902d7a34a06163632e6c5) perf: Show media resume option sheet only when duration is > 60s
- [b640f31](https://github.com/thevickypedia/Filebrowser-iOS/commit/b640f31f4477f9faf736544ae91c9810da984d17) refactor: Remove unworthy todo(s)
- [04cfae6](https://github.com/thevickypedia/Filebrowser-iOS/commit/04cfae6f48e17515b784ba357baab35d0fba76e4) perf: Remove redundant server hand-shake after recent auth
- [a550d47](https://github.com/thevickypedia/Filebrowser-iOS/commit/a550d47f942b0d2ab90d84c2e3164a429fc1dd6e) style: Include a buffer for upload speed refresh interval
- [90261ce](https://github.com/thevickypedia/Filebrowser-iOS/commit/90261ce9c11af0fe9c901baee1e3505b53a1b2be) perf: Display download speed and download file icon in list view
- [7cfd960](https://github.com/thevickypedia/Filebrowser-iOS/commit/7cfd9604c2022f9a88c0c5095cc12472fb491eca) refactor: Rearrange upload and download state vars in list view module
- [7e62039](https://github.com/thevickypedia/Filebrowser-iOS/commit/7e62039f2ee5f5c1b8c27c6e062fce6f74b0bed3) perf: Switch to type-safe session storage in Keychain and avoid redundant prefetch
- [224a0f2](https://github.com/thevickypedia/Filebrowser-iOS/commit/224a0f2051875d976da6057fd7eb18e3d8831e02) chore: Update release notes for v1.39.1

v1.39.1 (09/16/2025)
--------------------
- [c6e34ae](https://github.com/thevickypedia/Filebrowser-iOS/commit/c6e34aee585ba1b495f857816457b275880430c6) chore: Release ``v1.39.1``
- [c58c752](https://github.com/thevickypedia/Filebrowser-iOS/commit/c58c75204598eba79f2213a64c1b0801a9cc7278) perf: Remove code redundancies in download logic under detail view
- [ba35623](https://github.com/thevickypedia/Filebrowser-iOS/commit/ba35623e22c548d8d3818e922615c686e007b82e) perf: Improve UX notification and logging when upload fails
- [118d5e7](https://github.com/thevickypedia/Filebrowser-iOS/commit/118d5e745e934ab74bbc12c137c38df038dc5d0b) perf: Remove code redundancies in download operation under list view
- [d081134](https://github.com/thevickypedia/Filebrowser-iOS/commit/d081134e1c5f37d79a5567451fbe836b0b08c8f9) chore: Update release notes for v1.39.0

v1.39.0 (09/16/2025)
--------------------
- [eb727c7](https://github.com/thevickypedia/Filebrowser-iOS/commit/eb727c778b2fcc439e8569498405054f7b8649f4) chore: Release ``v1.39.0``
- [8d46c6e](https://github.com/thevickypedia/Filebrowser-iOS/commit/8d46c6e212d07bbbcc41096c40151041f110658e) lint: Fix identifier name violation
- [3d334b6](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d334b6fd496ac568ab95317fb2bb908d0b81606) feat: Automatically save files to photos/files app based on file types
- [c979592](https://github.com/thevickypedia/Filebrowser-iOS/commit/c97959225f7b2f28ca31890f11acfd4e13fd6fee) feat: Add a new feature to download file(s) from list view
- [78d06ed](https://github.com/thevickypedia/Filebrowser-iOS/commit/78d06ed1437902f3366d3522b0aa767941df78a4) chore: Update release notes for v1.38.0

v1.38.0 (09/15/2025)
--------------------
- [2928bc6](https://github.com/thevickypedia/Filebrowser-iOS/commit/2928bc61527c5784d945c7ecc1fa7b27d86218ce) chore: Release ``v1.38.0``
- [caeff97](https://github.com/thevickypedia/Filebrowser-iOS/commit/caeff976312ae32487f3b77fa20c5efd819c2587) perf: Remove deprecated windows function usage
- [9f94c91](https://github.com/thevickypedia/Filebrowser-iOS/commit/9f94c91b52a5d4f3d603e30ffd3ab512c69fc936) feat: Add a new feature to save images/videos to photos app
- [1cf0e48](https://github.com/thevickypedia/Filebrowser-iOS/commit/1cf0e486e25971da98e8c76fca2263bdbf6f6f54) chore: Update release notes for v1.37.2

v1.37.2 (09/11/2025)
--------------------
- [dda2356](https://github.com/thevickypedia/Filebrowser-iOS/commit/dda23564dad2535229087448e01152cb504a1b3d) chore: Release ``v1.37.2``
- [7243d0b](https://github.com/thevickypedia/Filebrowser-iOS/commit/7243d0b604b21e73542f3a5a2743cc52aacd9eb3) perf: Keep auto save and minimum resume threshold for videos in sync
- [342b031](https://github.com/thevickypedia/Filebrowser-iOS/commit/342b031e938872815397dbdc959207046326ee89) perf: Show alert and load default AVPlayer if metadata fetch fails
- [2405f31](https://github.com/thevickypedia/Filebrowser-iOS/commit/2405f31480c1d7bdb8c1d04bbc5a72761ffed53e) perf: Remove usage of deprecated functions
- [9de3223](https://github.com/thevickypedia/Filebrowser-iOS/commit/9de322368772a9a882de8388f30aaa2f9a91eee4) refactor: Remove un-used variables
- [0c4fec7](https://github.com/thevickypedia/Filebrowser-iOS/commit/0c4fec711b940c029eda67e969b7782dbbbd245c) perf: Add primary and secondary guard rails for resume-able media
- [6126bc5](https://github.com/thevickypedia/Filebrowser-iOS/commit/6126bc520024f9dbbdfc0dd18ccbd5bcdb74f09a) perf: Fallback to beginning of a video if user closes the sheet without choosing an option
- [8a22036](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a220360cb567f44b984bc2829999e26cf48c699) fix: Defer AVPlayer setup until the resume sheet decision is made
- [e191be4](https://github.com/thevickypedia/Filebrowser-iOS/commit/e191be4541884b54e0679cf38f9c3029df388f13) revert: Rollback fix for resume sheet missing timestamp
- [f106ff7](https://github.com/thevickypedia/Filebrowser-iOS/commit/f106ff77de83589acc7ee72c12810600471569fc) fix: Resume sheet missing timestamp
- [0723060](https://github.com/thevickypedia/Filebrowser-iOS/commit/072306087f7ae67ef167d7672aa98cd96ac1fd43) chore: Update release notes for v1.37.1

v1.37.1 (09/11/2025)
--------------------
- [5814455](https://github.com/thevickypedia/Filebrowser-iOS/commit/58144558c8245ce120de22f6ea1d81e308ddfacb) chore: Release ``v1.37.1``
- [5051dbd](https://github.com/thevickypedia/Filebrowser-iOS/commit/5051dbddcd8221a149005f528899e98a095cfbd7) perf: Store the last saved time for media files every 5s (instead of every 1s)
- [4bae941](https://github.com/thevickypedia/Filebrowser-iOS/commit/4bae941d5791c7a7b82b1880e6fc32e27198db78) feat: Store playback progress w.r.t ``username`` and ``serverURL``
- [fad140f](https://github.com/thevickypedia/Filebrowser-iOS/commit/fad140f1b22a9d430247d7901bc457076ca78faa) chore: Update release notes for v1.37.0

v1.37.0 (09/10/2025)
--------------------
- [f40a68b](https://github.com/thevickypedia/Filebrowser-iOS/commit/f40a68be85a41e2faff4e5f643cf7865ae3dc0c1) chore: Release ``v1.37.0``
- [ceb82dc](https://github.com/thevickypedia/Filebrowser-iOS/commit/ceb82dc8904f36cc78da359d0656dfd2f06cac84) feat: Add a new feature to store playback progress for media files
- [ef9718f](https://github.com/thevickypedia/Filebrowser-iOS/commit/ef9718f92efe4b5eafb906f00d4fdaa364e49ad1) ci: Ensure all GHA workflows run on self-hosted runners
- [f7b7024](https://github.com/thevickypedia/Filebrowser-iOS/commit/f7b70246d057bcf2426cc7cdf212c24b0183a923) chore: Update release notes for v1.36.1

v1.36.1 (09/10/2025)
--------------------
- [337b43f](https://github.com/thevickypedia/Filebrowser-iOS/commit/337b43fba088833ae2398ebe05b56d939434a526) chore: Release ``v1.36.1``
- [4455a94](https://github.com/thevickypedia/Filebrowser-iOS/commit/4455a9413d73c3f35d8fc71a4adaf68b129e65e1) ci: Handle project version that's already prefixed with ``v``
- [f14980c](https://github.com/thevickypedia/Filebrowser-iOS/commit/f14980c8dfd23ef34704111782410202c9006018) ci: Run release and release notes GHA on self-hosted runners
- [f5154c1](https://github.com/thevickypedia/Filebrowser-iOS/commit/f5154c139b140e0aaf4e351d3f54e2aa9adaaa0d) ci: Run build on self-hosted runner
- [34f2af8](https://github.com/thevickypedia/Filebrowser-iOS/commit/34f2af83bf4b7947aadff3d4e4e1d245a3c89b67) ci: Bump iOS version for tests
- [462383f](https://github.com/thevickypedia/Filebrowser-iOS/commit/462383fd00ad628fc49cb6ad1832fc3fb8d6908a) ci: Run tests on self-hosted runner
- [fa066d7](https://github.com/thevickypedia/Filebrowser-iOS/commit/fa066d73bea3576e218cfcdf19673367a8a19628) ci: Run linting on self-hosted runner
- [0ef70f9](https://github.com/thevickypedia/Filebrowser-iOS/commit/0ef70f9e11b7fbb5048658e2e921011abc2af32d) feat: Add a full-screen toggle button for images
- [18eacc6](https://github.com/thevickypedia/Filebrowser-iOS/commit/18eacc6cca89946d0be8999d87560247bb16ada6) feat: (for images) Store pinch or tap location and zoom in to the particular spot
- [a736cff](https://github.com/thevickypedia/Filebrowser-iOS/commit/a736cff97d297dd05dbef7d3d90f24ffada700b4) fix: Avoid moving to next and previous image when swiped in a zoomed in view
- [6e14ba0](https://github.com/thevickypedia/Filebrowser-iOS/commit/6e14ba07d72d343cc7095f7be109604fec3a0f8f) build: Update CF options in property list
- [d448147](https://github.com/thevickypedia/Filebrowser-iOS/commit/d448147a559cc64985fdc11fbda55bea0ee31b57) perf: Add new ``trace`` logging as foundation level
- [dafb847](https://github.com/thevickypedia/Filebrowser-iOS/commit/dafb847e8c6e1ccba1a79efb99019a9fcdcf6ecd) chore: Update release notes for v1.36.0

v1.36.0 (09/02/2025)
--------------------
- [ff0ef2e](https://github.com/thevickypedia/Filebrowser-iOS/commit/ff0ef2ed9f579e926eea91a0fb1d98c1a4851f0d) chore: Release ``v1.36.0``
- [3e1adc6](https://github.com/thevickypedia/Filebrowser-iOS/commit/3e1adc6068e26f494e1179cab162e2d4ed78559a) fix: Fix linting errors
- [7212d97](https://github.com/thevickypedia/Filebrowser-iOS/commit/7212d97f0946f81ab5d18e0b05dffe622e04a722) feat: Add a feature to upload files to remote server in the background
- [2cc7ba2](https://github.com/thevickypedia/Filebrowser-iOS/commit/2cc7ba270a1c98c49d14cba1b747536d284385f8) chore: Update release notes for v1.35.1

v1.35.1 (09/01/2025)
--------------------
- [86dc4d9](https://github.com/thevickypedia/Filebrowser-iOS/commit/86dc4d9a4028797580d53aca685c440db86faa0a) chore: Release ``v1.35.1``
- [4729d3b](https://github.com/thevickypedia/Filebrowser-iOS/commit/4729d3b0ce52288452acc21894f9fe367e987a03) chore: Add code markers
- [4aa7dc0](https://github.com/thevickypedia/Filebrowser-iOS/commit/4aa7dc0a5a3dc645adeccf8cb2b58523f70ecbc3) perf: Check if file exists before trying to copy/move items
- [67e0dd8](https://github.com/thevickypedia/Filebrowser-iOS/commit/67e0dd886a123378c12f1c31985259d7efe02282) chore: Update release notes for v1.35.0

v1.35.0 (09/01/2025)
--------------------
- [a1f3026](https://github.com/thevickypedia/Filebrowser-iOS/commit/a1f3026190325318dcaef6113005cf7fe4df7fb2) chore: Release ``v1.35.0``
- [db5ee7b](https://github.com/thevickypedia/Filebrowser-iOS/commit/db5ee7bf38f3f4d54008c2cf26ba164fb79a38ae) fix: Fix navigation inconsistencies within copy/move view
- [d336a6d](https://github.com/thevickypedia/Filebrowser-iOS/commit/d336a6d995a64cb4f32d7bc1797e17663cb287ba) fix: Build move/copy sheet path relative to root
- [4054ce2](https://github.com/thevickypedia/Filebrowser-iOS/commit/4054ce2d16ea50e663df386e005afbe68fa14512) style: Add a status message for copy/move sheet
- [bcbee4f](https://github.com/thevickypedia/Filebrowser-iOS/commit/bcbee4fab2b4ad06057fcfe4747c67664b8ef945) style: Display the current path instead of root in copy/move sheet
- [42e5eb8](https://github.com/thevickypedia/Filebrowser-iOS/commit/42e5eb890d5148f44685ff0bb80866b033658ace) fix: Fix relative path issue in move/copy action
- [a2d238b](https://github.com/thevickypedia/Filebrowser-iOS/commit/a2d238bfeca8ec2add047a7a6f2cb6bd51ee5f0b) style: Update icons and styling within selection action stack
- [ec6b7a5](https://github.com/thevickypedia/Filebrowser-iOS/commit/ec6b7a5a30bae6afbbcb6cd74d1b9b9356c7f7fc) feat: Implement logic to move or copy items
- [9e9c865](https://github.com/thevickypedia/Filebrowser-iOS/commit/9e9c865dfa2eb8254c5e3ca839225e7543d8b338) perf: Use enums to detect modify action type
- [c4de190](https://github.com/thevickypedia/Filebrowser-iOS/commit/c4de190a4a34ab67e445b0dd0f86a4c138a2814a) refactor: Restructure verbose logging
- [3cc50e2](https://github.com/thevickypedia/Filebrowser-iOS/commit/3cc50e2d6fdcdcd3337c214c923a3ed8361186ce) feat: Add a sheet view for move/copy to the destination directory
- [4b32941](https://github.com/thevickypedia/Filebrowser-iOS/commit/4b32941599fabb16d1a1b86db3f2f6e6af5ac3c0) feat: Add move and copy options (placeholder)
- [10f03b8](https://github.com/thevickypedia/Filebrowser-iOS/commit/10f03b80a01addbb955731d0b8b9ce432b874007) style: Move all selected options under a drop down menu
- [81e6b5c](https://github.com/thevickypedia/Filebrowser-iOS/commit/81e6b5c04e23f662144485c8feaefba50ae8ce8f) chore: Update release notes for v1.34.2

v1.34.2 (08/28/2025)
--------------------
- [8498dce](https://github.com/thevickypedia/Filebrowser-iOS/commit/8498dce39055c9d102b60bf05018052d0a2c9c7a) chore: Release ``v1.34.2``
- [764ab37](https://github.com/thevickypedia/Filebrowser-iOS/commit/764ab3733fe3c9cccdc22578886b8473d757e825) perf: Wrap thumbnail processing for images and GIFs in ``autoreleasepool`` to reduce memory usage
- [e18e460](https://github.com/thevickypedia/Filebrowser-iOS/commit/e18e460d6ec2cf7ec4e961c93768e6231aedfcd0) fix: Remove async dispatch to load thumbnails that bypassed queue concurrency limit
- [2d8903e](https://github.com/thevickypedia/Filebrowser-iOS/commit/2d8903e6b52d2c4420f3f110b172395790ccacf5) perf: Implement a queue functionality to avoid crashing when too many video thumbnails are rendered
- [7232bd7](https://github.com/thevickypedia/Filebrowser-iOS/commit/7232bd7c8cc46e1b5ff31e735706515dcbebd51f) dev: Create a dev script to automatically deploy XCode project to iPhone via network
- [2265abb](https://github.com/thevickypedia/Filebrowser-iOS/commit/2265abbc245b263ecf586b4254fe4f990d4b6e19) chore: Update release notes for v1.34.1

v1.34.1 (08/24/2025)
--------------------
- [bcff90b](https://github.com/thevickypedia/Filebrowser-iOS/commit/bcff90b1c3a5f4bf43c181607a483ff65863e001) chore: Release ``v1.34.1``
- [7ed2040](https://github.com/thevickypedia/Filebrowser-iOS/commit/7ed2040d3932bcd3566bf63acc31b9f8741b59f1) perf: Optimize logging with ``@autoclosure`` to defer message evaluation
- [3721017](https://github.com/thevickypedia/Filebrowser-iOS/commit/37210170e326ec8188b64099909f55054c2dcc7a) style: Maintain consistency in icon size for default thumbnail image
- [23c3b0b](https://github.com/thevickypedia/Filebrowser-iOS/commit/23c3b0b7f3d4b8c3c3d54945519e1cc50c8bd351) fix: Case sensitivity bug in ``systemIcon`` util function
- [23fbeef](https://github.com/thevickypedia/Filebrowser-iOS/commit/23fbeefc9ba3551098c0281ec851d9ce7989cf4b) style: Show thumbnail spinner immediately on visibility
- [fe8fd37](https://github.com/thevickypedia/Filebrowser-iOS/commit/fe8fd37d3da16057e1edaa83c5e264ab2dac65d7) chore: Update release notes for v1.34.0

v1.34.0 (08/24/2025)
--------------------
- [cb5f5bf](https://github.com/thevickypedia/Filebrowser-iOS/commit/cb5f5bf56b2a36b490b71a6fc0116dfa9370d5b4) chore: Release ``v1.34.0``
- [fe25914](https://github.com/thevickypedia/Filebrowser-iOS/commit/fe25914c392de800ed58c7155c9ad69b83ffc6b2) perf: Remove unnecessary casting, replace all print statements with logging and replace ``tracks(withMediaType:)`` with ``loadTracks(withMediaType:)``
- [494d02d](https://github.com/thevickypedia/Filebrowser-iOS/commit/494d02d76e2af1a7af76f9e5a03cb540e2ac1f68) perf: Avoid fetching media metadata for any action on lock screen or centrol center
- [bf44fe4](https://github.com/thevickypedia/Filebrowser-iOS/commit/bf44fe40c068dfcc2bae520670cba440f860dc16) chore: Include background processing and fetch
- [0fce37f](https://github.com/thevickypedia/Filebrowser-iOS/commit/0fce37f5c75388ec3f32ae19de038a15de73509b) lint: Fix linting errors
- [58381bc](https://github.com/thevickypedia/Filebrowser-iOS/commit/58381bc4d4dda80c59b2107cc32eece28d97c5e4) fix: Background media player on lock screen after adding a new capability
- [a960231](https://github.com/thevickypedia/Filebrowser-iOS/commit/a960231df65d615751c27e6ef7e1cf3494f471d8) fix: Handle session interruption for background video
- [78108aa](https://github.com/thevickypedia/Filebrowser-iOS/commit/78108aaa97998eaae3b5d0843208acd9e2e2c8e4) fix: Resolve ``Domain=NSOSStatusErrorDomain Code=-50``  caused by redundant ``setupAudioSession``
- [4ad4beb](https://github.com/thevickypedia/Filebrowser-iOS/commit/4ad4beb324a6d8af145331fd2f5a12d64176e6e4) feat: Add background compatibility for media player
- [c308ae2](https://github.com/thevickypedia/Filebrowser-iOS/commit/c308ae27c7397c8e2f803c0feefb4756b3d49f56) chore: Update release notes for v1.33.2

v1.33.2 (08/23/2025)
--------------------
- [00c7efb](https://github.com/thevickypedia/Filebrowser-iOS/commit/00c7efbc3eb40a36451cac09908b5fb06cc8c2ea) chore: Release ``v1.33.2``
- [df4e0ff](https://github.com/thevickypedia/Filebrowser-iOS/commit/df4e0ff18d9751c3674284ee6a1c8eb83325923a) perf: Include a full-screen mode for media player
- [8659b78](https://github.com/thevickypedia/Filebrowser-iOS/commit/8659b78c69c537253f375cec63fc5eaba5fa8ef0) fix: Infinite thumbnail fetch loop for invalid media files
- [dc9c321](https://github.com/thevickypedia/Filebrowser-iOS/commit/dc9c321519847bce46761efa88c941ed1cbd826c) style: Include username in the footer section of settings page
- [5b04e25](https://github.com/thevickypedia/Filebrowser-iOS/commit/5b04e2546cdbbac638c57a378ecf080e96252c21) chore: Update release notes for v1.33.1

v1.33.1 (08/22/2025)
--------------------
- [f9f6a44](https://github.com/thevickypedia/Filebrowser-iOS/commit/f9f6a448ea7f75fa1351d3079dd6e0a2685d317e) chore: Release ``v1.33.1``
- [a75dbfe](https://github.com/thevickypedia/Filebrowser-iOS/commit/a75dbfea389e479977bc11e536c1599ab99f2acb) ci: Pin GHA runners to ``macOS-14``
- [6d2f00b](https://github.com/thevickypedia/Filebrowser-iOS/commit/6d2f00b13da58a898887747d5b639184e6f05b8e) perf: Remove temp files after upload without waiting for automatic system cleanup
- [4ed4234](https://github.com/thevickypedia/Filebrowser-iOS/commit/4ed4234158d650f549a23fb1ff3876b214d3f3d5) chore: Add a CLI deployment dev script
- [f4038d0](https://github.com/thevickypedia/Filebrowser-iOS/commit/f4038d0b2d7f45a6035fc6ad449360d43d8eaaab) chore: Update release notes for v1.33.0

v1.33.0 (08/18/2025)
--------------------
- [3015f59](https://github.com/thevickypedia/Filebrowser-iOS/commit/3015f5936db075751c4eff9385e63c03ed85c28e) chore: Release ``v1.33.0``
- [41e6bc3](https://github.com/thevickypedia/Filebrowser-iOS/commit/41e6bc3267ad174d377fc556b08897f9fc4f5eaa) fix: False positive on server handshake due to username rendering HTML content
- [04b1055](https://github.com/thevickypedia/Filebrowser-iOS/commit/04b1055f69adb75e5604eb71a029c9ccde94eecc) perf: Remove navigation glitches by replacing debounced fetch with immediate state updates
- [83b01f5](https://github.com/thevickypedia/Filebrowser-iOS/commit/83b01f5b7383a1cf33aa5d000e2c54ec4042654c) lint: Fix line breaks
- [5f8135a](https://github.com/thevickypedia/Filebrowser-iOS/commit/5f8135af048a86dd3f707612e02a8b0acc8b840b) perf: Simplify permission validation in file list view
- [643c940](https://github.com/thevickypedia/Filebrowser-iOS/commit/643c94008852c84b399ddc6a57ade4bff83f0fa8) perf: Manage auth params and server hand shake more efficiently
- [3697be0](https://github.com/thevickypedia/Filebrowser-iOS/commit/3697be001654a7d7fb4ca177d036be325a4528fa) fix: Failing to get permissions for non-admin users
- [43e6e28](https://github.com/thevickypedia/Filebrowser-iOS/commit/43e6e28d75387d85db2783098e3ff4859446b2fb) perf: Onboard a ``JWTPayload`` struct for proper serialization
- [00fc06d](https://github.com/thevickypedia/Filebrowser-iOS/commit/00fc06daccf0c64edf3a49a0dbee67ee6286d1c0) revert: Rollback ``78e468e``:  Failing to get permissions for non-admin users
- [e6a8894](https://github.com/thevickypedia/Filebrowser-iOS/commit/e6a889426a6a20b2933cbdb536fafd17bbdb541c) style: Make switch user button smaller and padded
- [a325ca6](https://github.com/thevickypedia/Filebrowser-iOS/commit/a325ca64fd21d37c6b714e7dd6076f5290366bb2) perf: Prevent multiple ``NavigationRequestObserver`` updates per frame
- [7cc2d5c](https://github.com/thevickypedia/Filebrowser-iOS/commit/7cc2d5c65c546758aa1deeaa7dccab0b750b03ae) chore: Update release notes for v1.32.4

v1.32.4 (08/17/2025)
--------------------
- [e966a9d](https://github.com/thevickypedia/Filebrowser-iOS/commit/e966a9db4b33d31e50cb4de1c29243aaf1bce810) chore: Release ``v1.32.4``
- [1298bf2](https://github.com/thevickypedia/Filebrowser-iOS/commit/1298bf21cfad4e66e287d06ef9f7c820634f8ac0) perf: Include optional verbose logging
- [3e7e910](https://github.com/thevickypedia/Filebrowser-iOS/commit/3e7e910dcdcbf521e51632433d964dcbef09de92) feat: Include a new button to switch user after logout
- [19d0b53](https://github.com/thevickypedia/Filebrowser-iOS/commit/19d0b53e28d6cad15c63d32b1377ffd2dc816456) chore: Update release notes for v1.32.3

v1.32.3 (08/17/2025)
--------------------
- [39b3305](https://github.com/thevickypedia/Filebrowser-iOS/commit/39b33058ebb9080910fffc470a0f49c48bb65f47) chore: Release ``v1.32.3``
- [4f83467](https://github.com/thevickypedia/Filebrowser-iOS/commit/4f834679622988fbab79a606849dbf6718c44abf) fix: Bug fix cancel button in sharable links sheet
- [80672f2](https://github.com/thevickypedia/Filebrowser-iOS/commit/80672f23d34d422d7769bc277a3bea7a0ab489ce) style: Differentiate buttons for share and cancel in sharable links' sheet
- [9a53e51](https://github.com/thevickypedia/Filebrowser-iOS/commit/9a53e517a812a5d4967427defb9b68533f702e77) fix: Add a permissions check before showing sharable links option in list view
- [5a097a7](https://github.com/thevickypedia/Filebrowser-iOS/commit/5a097a7de8ee124f8b3c8b5206bcbf60c15dcdce) refactor: Reduce code complexity in login/content view
- [8f13403](https://github.com/thevickypedia/Filebrowser-iOS/commit/8f13403e315d9d6e40d2bd09a255f8b696163e4e) style: Display username on login button for saved sessions
- [78e468e](https://github.com/thevickypedia/Filebrowser-iOS/commit/78e468efc9479617dd9a24e063d7b682b09849f6) fix: Failing to get permissions for non-admin users
- [ca65cde](https://github.com/thevickypedia/Filebrowser-iOS/commit/ca65cde461ee7fb70deee513f7075f21cfaa9606) perf: Improve logging stack to include module, function and line information
- [5893cc0](https://github.com/thevickypedia/Filebrowser-iOS/commit/5893cc0f37501964f1d87a34596946e5af2c60a4) lint: Update linting
- [bc68e61](https://github.com/thevickypedia/Filebrowser-iOS/commit/bc68e6141d4a5bb2fd20aaeb4e47178d01d82fa0) refactor: Remove code redundancy between list and detail view for shared links
- [ce541ca](https://github.com/thevickypedia/Filebrowser-iOS/commit/ce541ca3d443efdd0aee5e133927fbf8ae61503a) feat: Include sharable links feature in ``FileDetailView``
- [4b8767f](https://github.com/thevickypedia/Filebrowser-iOS/commit/4b8767fa8da26764c49c68e66d59623e348fd83f) chore: Update release notes for v1.32.2

v1.32.2 (08/16/2025)
--------------------
- [a8ee9ab](https://github.com/thevickypedia/Filebrowser-iOS/commit/a8ee9abb93b7e8763db1f5a470c191de7efa5224) chore: Release ``v1.32.2``
- [51a3e3c](https://github.com/thevickypedia/Filebrowser-iOS/commit/51a3e3c02347abd11573e27811fae0e863393466) style: Improve error messages in the UI
- [6a951e0](https://github.com/thevickypedia/Filebrowser-iOS/commit/6a951e060e6ee2728c39c94e9e1be16392be24c8) refactor: Extract sheets into private views to reduce body size
- [9a080fa](https://github.com/thevickypedia/Filebrowser-iOS/commit/9a080fa53d739a7821aedd106e5787157e6e814a) style: Change share image to material icon
- [2abd349](https://github.com/thevickypedia/Filebrowser-iOS/commit/2abd34939bcbb620ef60be54d90b37c8bea50a03) feat: Allow users to delete shared links, along with auto-deletion
- [ce64975](https://github.com/thevickypedia/Filebrowser-iOS/commit/ce6497526d8ab82cc0c8a848d7b56bda964325e6) fix: Prevent creating multiple share links for the same resource
- [4c475ed](https://github.com/thevickypedia/Filebrowser-iOS/commit/4c475ed9c6450dfb6a1b4596a47781379e432a9a) chore: Update release notes for v1.32.1

v1.32.1 (08/16/2025)
--------------------
- [961eed1](https://github.com/thevickypedia/Filebrowser-iOS/commit/961eed1b3dee51607578956e40e0e2c1e6aad201) chore: Release ``v1.32.1``
- [8a89a40](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a89a40f6ad9e4d5364da69a0cc671a4e4ea0f70) style: Display a warning message for empty passwords when generating share links
- [331743a](https://github.com/thevickypedia/Filebrowser-iOS/commit/331743a0165d84dd8a2512ecbd7e0257f17c8a9e) style: Show feedback when share links are copied to clipboard
- [2185b31](https://github.com/thevickypedia/Filebrowser-iOS/commit/2185b31d07c5bca33fead28958fe138703bd7793) chore: Update release notes for v1.32.0

v1.32.0 (08/16/2025)
--------------------
- [57789f3](https://github.com/thevickypedia/Filebrowser-iOS/commit/57789f388e579dc5598e10fa3aea97c655afc77c) chore: Release ``v1.32.0``
- [d945755](https://github.com/thevickypedia/Filebrowser-iOS/commit/d945755dd577a9d7c82650adb4158fae5c7b186a) feat: Allow users to share a selected item from ``FileListView``
- [9f49322](https://github.com/thevickypedia/Filebrowser-iOS/commit/9f493222c2719d55fa4282d84761a7e2e4f14309) chore: Update release notes for v1.31.2

v1.31.2 (08/14/2025)
--------------------
- [2b48210](https://github.com/thevickypedia/Filebrowser-iOS/commit/2b482107aaf2c5bbc67332ecb7beb657c1ff970c) chore: Release ``v1.31.2``
- [9f610fd](https://github.com/thevickypedia/Filebrowser-iOS/commit/9f610fd06d4f02caa4459bfbebdff7fd1f1347a6) chore: Set default log level to warning and remove stale todo
- [8ba79f4](https://github.com/thevickypedia/Filebrowser-iOS/commit/8ba79f415264b4deb2aa1a0bfd18ed7619d9d34c) fix: Avoid array index out of bounds error during drag gesture in detail view
- [51219d5](https://github.com/thevickypedia/Filebrowser-iOS/commit/51219d5d41ebe8fba90fed9a8184096552486789) fix: Create a ``GlobalThumbnailLoader`` to avoid repeated I/O operations for thumbnails
- [a7c4b05](https://github.com/thevickypedia/Filebrowser-iOS/commit/a7c4b05e46a5dd94a4201e22251476b5df445625) style: Overlay play icon for video thumbnails
- [a4c71ad](https://github.com/thevickypedia/Filebrowser-iOS/commit/a4c71ad1f99f5771f44e4993948644ce4abf26ee) chore: Update release notes for v1.31.1

v1.31.1 (08/13/2025)
--------------------
- [1fd2c5d](https://github.com/thevickypedia/Filebrowser-iOS/commit/1fd2c5d7af96b6558b2de3a1a236dd172fa97520) chore: Release ``v1.31.1``
- [af53301](https://github.com/thevickypedia/Filebrowser-iOS/commit/af53301f910199736470fef72495f0aeef6132a0) perf: Compress video thumbnails as JPEG with fallback logic to PNG

v1.31.0 (08/13/2025)
--------------------
- [6a76aea](https://github.com/thevickypedia/Filebrowser-iOS/commit/6a76aea533fe05a518d9c28ea9e72343b071286b) chore: Release ``v1.31.0``
- [3dcd4c5](https://github.com/thevickypedia/Filebrowser-iOS/commit/3dcd4c51d0b6cddca783efa372bb3f298cca4682) feat: Add thumbnail for video files in listing page
- [69d7e25](https://github.com/thevickypedia/Filebrowser-iOS/commit/69d7e25401e663a73b79432b0b1c1683ed4423e2) chore: Update release notes for v1.30.1

v1.30.1 (08/13/2025)
--------------------
- [973f986](https://github.com/thevickypedia/Filebrowser-iOS/commit/973f986f5cad7c00e9241a2c5040c12f8a450654) chore: Release ``v1.30.1``
- [efc8a5b](https://github.com/thevickypedia/Filebrowser-iOS/commit/efc8a5be0b488c19eec172190a06923fecdafe7a) fix: Failing to sync settings with the global auth state
- [9f5e87e](https://github.com/thevickypedia/Filebrowser-iOS/commit/9f5e87e7820fee90c70eed71471c5b82da668de2) perf: Replace checking auth state in each listing functionality with an init method
- [f2ea67d](https://github.com/thevickypedia/Filebrowser-iOS/commit/f2ea67dc3e08680f7125c0674c3c44dc89b797f5) chore: Update release notes for v1.30.0

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

v1.29.3 (08/11/2025)
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

v1.26.1 (08/10/2025)
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

v1.24.2 (08/09/2025)
--------------------
- [6be9921](https://github.com/thevickypedia/Filebrowser-iOS/commit/6be992110301b0d3317691d245359b1b87ed39ce) chore: Release ``v1.24.2``
- [8a81fca](https://github.com/thevickypedia/Filebrowser-iOS/commit/8a81fca64b7266a3c6a1e110bfce6de95ee5b71a) fix: Ensure credentials are not empty before server connection
- [7da409f](https://github.com/thevickypedia/Filebrowser-iOS/commit/7da409f14f1989358bbaf88141114586179274b7) fix: Catch invalid URLs when adding a new one
- [00c9d3e](https://github.com/thevickypedia/Filebrowser-iOS/commit/00c9d3e0439d4b3fcd7818a4b962e6cb70133761) chore: Update release notes for v1.24.1

v1.24.1 (08/09/2025)
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

v1.22.2 (08/08/2025)
--------------------
- [83307b3](https://github.com/thevickypedia/Filebrowser-iOS/commit/83307b3e7730bfbc61273d30dd50816fb58edc96) chore: Release ``v1.22.2``
- [259f42d](https://github.com/thevickypedia/Filebrowser-iOS/commit/259f42d2de6c3785bc7ae5a334d8781630b78f0d) fix: Remove redundant logout logic
- [899d3f4](https://github.com/thevickypedia/Filebrowser-iOS/commit/899d3f4a5866302a019875edff40e741bd1d1801) fix: Remove error message when faceID fails
- [3ff25cf](https://github.com/thevickypedia/Filebrowser-iOS/commit/3ff25cf65dd2a7b5ea05f2891d88f474e620194d) fix: Avoid automatically logging in when FaceID is registered
- [9680221](https://github.com/thevickypedia/Filebrowser-iOS/commit/96802218d65f5635dccee048ea57dfcc8b7e5f21) fix: Set a fallback for username and password if FaceID fails
- [d3b91ac](https://github.com/thevickypedia/Filebrowser-iOS/commit/d3b91ac67affba16ee5a3ef85a2629edf63b46b1) chore: Update release notes for v1.22.1

v1.22.1 (08/08/2025)
--------------------
- [2199136](https://github.com/thevickypedia/Filebrowser-iOS/commit/219913619165cf73b52396fc80182d1e72953693) chore: Release ``v1.22.1``
- [04c9c5c](https://github.com/thevickypedia/Filebrowser-iOS/commit/04c9c5cfdc18db7f1bbef4d12757ad9790291c6d) fix: Check for saved session before giving an option for FaceID
- [0673e8c](https://github.com/thevickypedia/Filebrowser-iOS/commit/0673e8caa3878972c3be7cb1a366f0b6d16b6125) fix: Make Face ID button visible
- [4dec964](https://github.com/thevickypedia/Filebrowser-iOS/commit/4dec9646d84609926524fd1f963dbfcdd6d37bc6) perf: Improve the usage for Face ID based on a top level var
- [adfc197](https://github.com/thevickypedia/Filebrowser-iOS/commit/adfc197fbd6a18f5ab0ae63cf56680aa41e3e451) chore: Update release notes for v1.22.0

v1.22.0 (08/08/2025)
--------------------
- [594b62f](https://github.com/thevickypedia/Filebrowser-iOS/commit/594b62f3d64b3f9db08c7e5f637be4e1d281d9ce) chore: Release ``v1.22.0``
- [5972b91](https://github.com/thevickypedia/Filebrowser-iOS/commit/5972b91cf51375cad9fcdb43b0312472e0d520f2) feat: Include support for Face ID
- [a9952d9](https://github.com/thevickypedia/Filebrowser-iOS/commit/a9952d9392e5c49ca76b68b318a3caf313d6f38a) revert: Revert refactor for individual modules
- [1a1a558](https://github.com/thevickypedia/Filebrowser-iOS/commit/1a1a5588da738ba2c769177e1d4996ec6cea4263) refactor: Create individual modules for cell and thumbnail views
- [29d6971](https://github.com/thevickypedia/Filebrowser-iOS/commit/29d697135f8b6d80dced8d536b9bca8976ad87e6) chore: Update release notes for v1.21.3

v1.21.3 (08/08/2025)
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

v1.18.0 (08/07/2025)
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

v1.16.4 (08/06/2025)
--------------------
- [e3403f3](https://github.com/thevickypedia/Filebrowser-iOS/commit/e3403f3d5a898ad7b2394569b21c729044b30fe1) chore: Release ``v1.16.4``
- [8b6b4cc](https://github.com/thevickypedia/Filebrowser-iOS/commit/8b6b4cc609060d422a43226b25008bc56a8a36e0) style: Include a percentage indicator in upload progress view
- [3c997a2](https://github.com/thevickypedia/Filebrowser-iOS/commit/3c997a270d5cda96fee8f0e9e0b917fd561b81bd) chore: Update release notes for v1.16.3

v1.16.3 (08/06/2025)
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

v1.13.5 (08/05/2025)
--------------------
- [d884bcb](https://github.com/thevickypedia/Filebrowser-iOS/commit/d884bcb0c6f23e39c70dc5ff39d4fcec3bb3d84f) chore: Release ``v1.13.5``
- [53b5a25](https://github.com/thevickypedia/Filebrowser-iOS/commit/53b5a2592a665aa13c20601ca6f99f737d31c305) style: Re-arrange icons in list and detail view
- [97ffffe](https://github.com/thevickypedia/Filebrowser-iOS/commit/97ffffe5d048aa6e7010b1ddf83fc8b303ec547a) chore: Update release notes for v1.13.4

v1.13.4 (08/05/2025)
--------------------
- [9bf7512](https://github.com/thevickypedia/Filebrowser-iOS/commit/9bf7512c60155120084c66f7770a2d5f9ae71faf) chore: Release ``v1.13.4``
- [d5af71c](https://github.com/thevickypedia/Filebrowser-iOS/commit/d5af71cd01807792f3a64d680b2e52ef964fabea) style: Display only the relevant icons in selection mode
- [72ab4b9](https://github.com/thevickypedia/Filebrowser-iOS/commit/72ab4b9a9e2ba3a32ab2e41c926fc650e2aa4a6d) chore: Update release notes for v1.13.3

v1.13.3 (08/05/2025)
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

v1.3.0 (07/26/2025)
-------------------
- [ae9733b](https://github.com/thevickypedia/Filebrowser-iOS/commit/ae9733b281d2afe66970212e805e2d95d481e10b) chore: Release v1.3.0
- [01ed580](https://github.com/thevickypedia/Filebrowser-iOS/commit/01ed5800bd0faf0203de8e86c0561788c3462d98) ci: Update release notes format to markdown
- [6acd0f0](https://github.com/thevickypedia/Filebrowser-iOS/commit/6acd0f009aee2c744a17a7b08d5381c3b5c5233d) fix: Remove unsupported video formats
- [3d4af43](https://github.com/thevickypedia/Filebrowser-iOS/commit/3d4af4305a7add85b0ca618b56cb010935cb707f) fix: Include a missing fetch call for file metadata
- [2014e28](https://github.com/thevickypedia/Filebrowser-iOS/commit/2014e28e60d81ea2ffae1dc47bde5ca611032cb7) fix: Add a helper function to format file size in info tab
- [dcdfb7a](https://github.com/thevickypedia/Filebrowser-iOS/commit/dcdfb7aec7333b422ba86118d087bbad54d80818) fix: Use dateFormatExact flag to display file modified info
- [c019a64](https://github.com/thevickypedia/Filebrowser-iOS/commit/c019a644093327b919d3ca95ba424305b22290bc) feat: Include an option to set exact date format via settings
- [f1ca457](https://github.com/thevickypedia/Filebrowser-iOS/commit/f1ca457211248eadab79e3ab3d17c87fb5131481) chore: Update release notes for v1.2.1

v1.2.1 (07/25/2025)
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
