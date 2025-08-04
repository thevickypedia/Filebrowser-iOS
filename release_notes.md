Release Notes
=============

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
