commit 4be0395315fc002cb58d3449afbf4d7e7e408109
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sun Feb 28 03:54:04 2016 +0000

    final

commit 26b1be933ffce34924c5dc744f90a7f84586c4a8
Merge: 70e2184 9601cf7
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sun Feb 28 03:50:16 2016 +0000

    Merge branch 'develop' of https://github.com/RooknRolll/rooknroll-chess into develop

commit 70e2184faa07698c1812564db4c79b837799d851
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sun Feb 28 03:42:36 2016 +0000

    rook logic added, tests pass

commit 9601cf7f8f51a36c2f78d0665d570fbab172ba40
Author: Brandon <dino217@users.noreply.github.com>
Date:   Sat Feb 27 18:46:17 2016 -0800

    Update king.rb
    
    Removed reference to byebug gem that was causing the production environment to crash.

commit ac42bdf60e0d4af82c9019397cfd8546d9fdf814
Merge: 48e62c4 edd9edd
Author: Brandon <dino217@users.noreply.github.com>
Date:   Sat Feb 27 18:21:00 2016 -0800

    Merge pull request #26 from RooknRolll/AB/king-model
    
    Ab/king model

commit edd9edd641056f630b72e52df95e54120ae24c02
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sun Feb 28 02:08:15 2016 +0000

    one_space? function updated, all tests pass

commit 4d97fb702b097de43b26eecae266a2346dfbbd05
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sun Feb 28 00:32:04 2016 +0000

    one_space? not working

commit 26d932712e1a2b59529c0ce2425f02c3890f8896
Merge: 784371d 48e62c4
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sat Feb 27 23:41:15 2016 +0000

    Merge branch 'develop' into AB/king-model

commit 784371d7146271d0c025b4cee4235ef841687599
Merge: 55e861e 879023a
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sat Feb 27 23:39:59 2016 +0000

    factorygirl merge issue fixed

commit 48e62c41b7a427503b6945b7e44b4765067673e8
Merge: 879023a 0a5299c
Author: Brandon <dino217@users.noreply.github.com>
Date:   Sat Feb 27 15:37:16 2016 -0800

    Merge pull request #25 from RooknRolll/valid-move-knight
    
    Valid move knight

commit 55e861e8e8e46f20b7b4e199e2fb95a69d9a6e59
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sat Feb 27 23:33:20 2016 +0000

    king model updated

commit 0a5299c4cb2efbd307467ac311a740b0a14ca639
Author: Nathan <nathangelliott@gmail.com>
Date:   Sat Feb 27 23:30:23 2016 +0000

    Updated knight model and specs

commit cb16375fd233c5633abbc66f94b9b8b0715ae2bd
Merge: d28d429 879023a
Author: Nathan <nathangelliott@gmail.com>
Date:   Sat Feb 27 23:26:07 2016 +0000

    Merge branch 'develop' into valid-move-knight

commit d28d4292aaeb541bbffc315edb024ad9ec58d26f
Author: Nathan <nathangelliott@gmail.com>
Date:   Sat Feb 27 23:25:24 2016 +0000

    Updated the knight model and spec

commit 879023aa78e60204fb96763d4fb7467c09ce14e4
Merge: 7d2f702 2ccf021
Author: Nathan Elliott <nathangelliott@gmail.com>
Date:   Sat Feb 27 18:24:01 2016 -0500

    Merge pull request #24 from RooknRolll/BR/Fix_moving_pieces
    
    Fixed a problem where attempting to move a piece caused an argument e…

commit 2ccf0216e03d0c3ab2fb7766f50d40984ce82d6a
Author: dino217 <brob217@gmail.com>
Date:   Sat Feb 27 15:16:51 2016 -0800

    Fixed a problem where attempting to move a piece caused an argument error.

commit 10e29e5a5b19c97f847d0ad2c2455175d1178d00
Merge: 3661935 7d2f702
Author: Nathan <nathangelliott@gmail.com>
Date:   Sat Feb 27 22:41:50 2016 +0000

    Merge branch 'develop' into valid-move-knight

commit 366193517b2a03a1ce1b2ecb487a08627bdeb13a
Author: Nathan <nathangelliott@gmail.com>
Date:   Sat Feb 27 22:40:31 2016 +0000

    Added tests for knight model spec

commit 7d2f7022fc4a3e74b8bc2468d5cd558fd6341aa1
Merge: bd176d5 f6f6363
Author: Nathan Elliott <nathangelliott@gmail.com>
Date:   Sat Feb 27 17:35:15 2016 -0500

    Merge pull request #23 from RooknRolll/BR/Bishop_Valid_Move
    
    Br/bishop valid move

commit f6f636380612330c47c6eb2f63676b5f2da6a1ee
Author: dino217 <brob217@gmail.com>
Date:   Sat Feb 27 14:04:23 2016 -0800

    Now calling the valid_move? method in update action in the piece controller.

commit e43afd4ccad63c30eabbc44d2c591c61a9ac0442
Author: dino217 <brob217@gmail.com>
Date:   Sat Feb 27 13:51:09 2016 -0800

    Created valid_move? method for Bishop model.

commit ec0dbc3153b857ade01e94e920d0cdb7fda93d20
Author: Nathan <nathangelliott@gmail.com>
Date:   Fri Feb 26 22:00:03 2016 +0000

    Added knight_spec.rb to model specs

commit 92a71fb8166f302205f53eb3e13c666fe73797ad
Author: Andrew Brink <abrink27@gmail.com>
Date:   Fri Feb 26 04:30:19 2016 +0000

    fixed format

commit bbc5c47b078de5718c0377cb8df8c070255f1b97
Author: Andrew Brink <abrink27@gmail.com>
Date:   Fri Feb 26 04:15:16 2016 +0000

    added logic for king

commit ee01eaeb18ccb4061ef11173301b0876de9e38e3
Author: Andrew Brink <abrink27@gmail.com>
Date:   Fri Feb 26 03:40:05 2016 +0000

    king logic added

commit bd176d58bca5098399be23f92db4fc40745a7cdf
Merge: 7e90f29 688ae3a
Author: Nathan Elliott <nathangelliott@gmail.com>
Date:   Thu Feb 25 18:54:05 2016 -0500

    Merge pull request #22 from RooknRolll/BR/Games_Create_Action
    
    Games create action now creates a game and sets the games white_playe…

commit 688ae3a3320669927231f03f531321e7bada4af9
Author: dino217 <brob217@gmail.com>
Date:   Thu Feb 25 14:30:28 2016 -0800

    Games create action now creates a game and sets the games white_player_id to the creating player's id.

commit 7e90f294a318deac16164d8e8ccbc1ab1347a0d3
Merge: 1eaa7a9 9448b34
Author: kasiejun <jeoncas@gmail.com>
Date:   Mon Feb 22 21:29:23 2016 -0500

    Merge pull request #21 from RooknRolll/join-a-game
    
    Talked to Nathan about this.

commit 9448b343ded5793b36269d0313306b007a69cdf6
Author: Nathan <nathangelliott@gmail.com>
Date:   Tue Feb 23 01:00:15 2016 +0000

    Updated request spec for joining a game

commit 0749d04bf36efd783f74c7f18863ed1189dd22bf
Author: Nathan <nathangelliott@gmail.com>
Date:   Mon Feb 22 16:48:15 2016 +0000

    Added support for joining an open game from the games index page

commit 91e8afc19cd8627a04a2b016cc2eab67b20c85bf
Author: Nathan <nathangelliott@gmail.com>
Date:   Fri Feb 19 21:34:09 2016 +0000

    Added Devise test helpers for controllers

commit 58fdeebb4d1e15c9a531673cab0ab1f0819c8ffa
Author: Nathan <nathangelliott@gmail.com>
Date:   Fri Feb 19 19:33:54 2016 +0000

    Added requests directory to spec directory

commit 1eaa7a9910197ac4342efba1a8b58f18c9129763
Merge: 8a7d316 9442009
Author: Nathan Elliott <nathangelliott@gmail.com>
Date:   Fri Feb 19 08:59:21 2016 -0500

    Merge pull request #20 from RooknRolll/BR/moving_pieces
    
    Br/moving pieces

commit 9442009f053021a59304ee110dba67595cfa71c4
Author: dino217 <brob217@gmail.com>
Date:   Thu Feb 18 21:13:57 2016 -0800

    Removed pending pieces_helper_spec test.

commit a18b2b42564d23deb65ddeaf8a7d44d408d2dafe
Author: dino217 <brob217@gmail.com>
Date:   Thu Feb 18 21:02:49 2016 -0800

    Now able to move pieces. There are still no validations happening prior to the move.

commit 8a7d316bd866c7d0c782c4db7f045cd14fc400e3
Merge: 3c73ab5 2b900ad
Author: kasiejun <jeoncas@gmail.com>
Date:   Thu Feb 18 23:32:03 2016 -0500

    Merge pull request #18 from RooknRolll/BR/draw_pieces_on_board
    
    Br/draw pieces on board

commit 21e4175c4225734bc5a92ea94498b47ca42070c0
Author: dino217 <brob217@gmail.com>
Date:   Thu Feb 18 20:04:28 2016 -0800

    Created piece show page for the purpose of moving a piece. The chosen piece is highlighted orange.

commit 3c73ab517986515fe05bf7fd02311f0b1b42ba69
Merge: ec8ad2c 385bd03
Author: Brandon <dino217@users.noreply.github.com>
Date:   Thu Feb 18 19:37:54 2016 -0800

    Merge pull request #19 from RooknRolll/populate
    
    Populate

commit 2b900ad6314ec75c325d0aa900b644a4fc82c1f2
Author: dino217 <brob217@gmail.com>
Date:   Thu Feb 18 19:13:12 2016 -0800

    Added comments explaining what the methods I made do. Removed a couple of unnecessary comment lines from the show games view.

commit a19841e80b8d3c219eba6c365a899a60752211ff
Author: dino217 <brob217@gmail.com>
Date:   Thu Feb 18 18:43:31 2016 -0800

    Drawing pieces on board with glyphicons.

commit 670f8b9c2cfdcfd1bbed7bc184a2f049f50c5b94
Author: dino217 <brob217@gmail.com>
Date:   Wed Feb 17 22:39:02 2016 -0800

    Heavily refactored the game show view. Created a self.find_by_coordinates method for pieces.

commit 385bd0379cfe1e8a741824c28f9760a1c51f6c41
Author: dino217 <brob217@gmail.com>
Date:   Wed Feb 17 20:37:26 2016 -0800

    Changed piece_spec.rb to destroy all pieces on the board before populating it with pieces to be tested.

commit 186907ff888d9c0ab036b0e71deb1030c2ea10b1
Author: Kasie Jun <jeoncas@gmail.com>
Date:   Thu Feb 18 02:49:27 2016 +0000

    Failing Test

commit ec8ad2cc07b33a3d7fd8d495335109e8bf8bbec8
Merge: 075a00d cb6b55d
Author: kasiejun <jeoncas@gmail.com>
Date:   Wed Feb 17 09:06:59 2016 -0500

    Merge pull request #17 from RooknRolll/AB/omniauth
    
    omniauth added for facebook authentication

commit cb6b55d9421b6210db943d4496c1d7c23f86c837
Author: Andrew Brink <abrink27@gmail.com>
Date:   Wed Feb 17 05:38:46 2016 +0000

    omniauth added for facebook authentication

commit 075a00d71c7a29cf115e3bd92538460c81effd2c
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Wed Feb 17 16:35:12 2016 +1100

    Fixed some of the Rubocop violations from my code

commit 4558ad84fc6868f037c4f73699ad76140aca7ac7
Author: dino217 <brob217@gmail.com>
Date:   Tue Feb 16 20:29:11 2016 -0800

    removed the .DS_Store file add by the last commit.

commit de831e354764230e54ff62d7974e6695b959e439
Merge: 4f72b2c 171037a
Author: Brandon <dino217@users.noreply.github.com>
Date:   Tue Feb 16 20:09:33 2016 -0800

    Merge pull request #16 from RooknRolll/AB/rubocop
    
    rubocop installed

commit 171037a9e178744ec6fba54aa8ee36eb9b81bd2c
Author: Andrew Brink <abrink27@gmail.com>
Date:   Wed Feb 17 03:37:58 2016 +0000

    rubocop installed

commit 4f72b2c4f75e2ca0e651065b7b5091e3317b849d
Merge: a95e9c8 02f5592
Author: Brandon <dino217@users.noreply.github.com>
Date:   Tue Feb 16 17:28:41 2016 -0800

    Merge pull request #15 from RooknRolll/add-board
    
    Add board

commit 02f5592651eaf77161914cd41d7ecee239fde232
Author: Nathan <nathangelliott@gmail.com>
Date:   Wed Feb 17 01:26:59 2016 +0000

    Changed black, white space order on chess board

commit 6bf380c52b218c4ea0a0e88dc5b83f38fbfbd595
Author: Nathan <nathangelliott@gmail.com>
Date:   Tue Feb 16 22:48:06 2016 +0000

    Created the Chess Board

commit 7466d8b162bd374b207740d6fe6d95920227c53c
Author: Nathan <nathangelliott@gmail.com>
Date:   Tue Feb 16 15:19:05 2016 +0000

    Added show page to games

commit a95e9c8173d8ceb74dfb5c2b037885fb999e895a
Merge: 1b1b9e9 22a620d
Author: Trevor Johnson <arubyrailsdev@gmail.com>
Date:   Tue Feb 16 21:12:00 2016 +1100

    Merge pull request #14 from RooknRolll/BR/game_with_ope_seats
    
    Br/game with open seats

commit 1b1b9e983985c615ea3349cec41f465eea2d4a3f
Merge: f1e70fc 9cafbae
Author: Trevor Johnson <arubyrailsdev@gmail.com>
Date:   Tue Feb 16 21:05:54 2016 +1100

    Merge pull request #13 from RooknRolll/BR/is_obstructed_method
    
    Br/is_obstructed? method

commit 9cafbae1edb82c34cd445c023a2b2c14cdcfbc12
Author: dino217 <brob217@gmail.com>
Date:   Mon Feb 15 20:44:56 2016 -0800

    Refactored the is_obstructed? method significantly pulling most of the code out into private methods.

commit 22a620d4638ee30020f5d4f6da84a938b4c3e00a
Author: dino217 <brob217@gmail.com>
Date:   Mon Feb 15 19:31:18 2016 -0800

    Created a query method on the game model that returns games that could take another player.

commit a6af19b5858f97c7516937b680e2aabb79327909
Author: dino217 <brob217@gmail.com>
Date:   Mon Feb 15 16:52:34 2016 -0800

    I added a missing migration. When I merged Andrew's pull request there were two migrations that created the games table. I deleted Andrews. I then created a new migration to add the names column in, but I forgot to add it before commiting and pushing.

commit c270918a418c6032c0f91e4ee1e3291da8439a0c
Author: dino217 <brob217@gmail.com>
Date:   Mon Feb 15 16:43:30 2016 -0800

    Refactored the is_obstructed? method significantly, moving some of it's checks into separte methods.

commit 13dcd2354f06a8b3064ddb2aae7cd5f4bd9dbd51
Author: dino217 <brob217@gmail.com>
Date:   Mon Feb 15 15:05:59 2016 -0800

    is_obstructed method passing all tests. Needs refactoring to reduce cyclomatic complexity.

commit 664d0dff49a2e9306075dbf9ee38b25e7404926a
Author: dino217 <brob217@gmail.com>
Date:   Mon Feb 15 11:06:51 2016 -0800

    Wrote tests to check upcoming is_obstructed? method.

commit f1e70fc379a3e1c46497d69a6a50c4ffe72660ee
Merge: e3882a9 871e9a9
Author: Brandon <dino217@users.noreply.github.com>
Date:   Mon Feb 15 10:51:16 2016 -0800

    Merge pull request #12 from RooknRolll/update-README
    
    Added wireframe links to the README

commit 871e9a95589c28ad46d2e574915fa7b6465ed1fd
Author: Nathan <nathangelliott@gmail.com>
Date:   Mon Feb 15 18:45:18 2016 +0000

    Added wireframe links to the README

commit e3882a9a06e3492d0fb029162feef5e4d4b7baa2
Merge: 695020d 0e866f9
Author: Brandon <dino217@users.noreply.github.com>
Date:   Mon Feb 15 09:27:28 2016 -0800

    Merge pull request #11 from RooknRolll/sti
    
    Setup single table inheritance for pieces

commit 0e866f949438f18b70424c7b8340063db7ef0f65
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Mon Feb 15 11:07:57 2016 +0000

    fixed typo in model/game.rb file

commit 5838c6f1d02b4a224f13140448f6c37e6431da36
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Mon Feb 15 22:01:29 2016 +1100

    Initial setup of single table inheritance

commit 695020d2e5042ad292581f83ed3639b06823f880
Merge: 455b65c b4074e6
Author: Brandon <dino217@users.noreply.github.com>
Date:   Sun Feb 14 22:36:31 2016 -0800

    Merge pull request #10 from RooknRolll/fix_rspec
    
    Adjusted Rspec to work with the game model

commit b4074e6906cbebdb0a86759a265d9f1dd33c0e0e
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Mon Feb 15 05:55:52 2016 +0000

    fixed Rspec to work with games and piece after last merge for the game model. Also removed test unit as we use Rspec.

commit 455b65c07b59b3a6a40247887b08573be2659f10
Merge: 9749ea0 b42981c
Author: Brandon <dino217@users.noreply.github.com>
Date:   Sun Feb 14 12:22:28 2016 -0800

    Merge pull request #7 from RooknRolll/AB/game-model
    
    Ab/game model

commit b42981ce14420f3f4e3d660c1f1abea2ef804827
Author: dino217 <brob217@gmail.com>
Date:   Sun Feb 14 12:11:55 2016 -0800

    Fixed styling issues.

commit 4d3215286f01bb50f3aa7f92c354bfa71090f473
Merge: 422c09b d0524a3
Author: dino217 <brob217@gmail.com>
Date:   Sun Feb 14 12:06:57 2016 -0800

    Resolved conflicts between develop branch and this branch.

commit 9749ea01e816def620f49794aae9b619d4cded2a
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Sun Feb 14 11:48:50 2016 +0000

    I had the method in the static_pagers controller commented out by mistake

commit 422c09b8aa7e7074eb3ec479a9909f8c6ce3c56e
Merge: b4e8fbd d304de4
Author: dino217 <brob217@gmail.com>
Date:   Sat Feb 13 15:50:08 2016 -0800

    Merged

commit b4e8fbdbf87788bdd16b19d0830a1b49f410af35
Merge: 240d778 16b325e
Author: dino217 <brob217@gmail.com>
Date:   Sat Feb 13 15:45:18 2016 -0800

    Merge branch 'develop' into AB/game-model
    
    Conflicts:
    	db/schema.rb

commit d0524a3bac17eb1eeb6c0fe8891de25ddce50e90
Merge: 77d723e 74a3bbf
Author: abrink27 <abrink27@gmail.com>
Date:   Sat Feb 13 15:34:39 2016 -0800

    Merge pull request #5 from RooknRolll/br/setup-models
    
    Set up models for Game and Pieces. Built associations between them.

commit 77d723ef875cf773274315d675f3a58129a33e67
Merge: 16b325e 21b4c4c
Author: Nathan Elliott <nathangelliott@gmail.com>
Date:   Thu Feb 11 09:03:30 2016 -0500

    Merge pull request #8 from RooknRolll/add_rspec
    
    Added Rspec + FactoryGirl and wrote a simple test.

commit 21b4c4cb293178967f18c4d58108b8be79dfb649
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Thu Feb 11 20:38:01 2016 +1100

    Added Rspec and FactoryGirl and wrote a simple
    test to check the landing page was loading correctly.

commit d304de49cef9dffc833e5eb5f9db61a1602030dd
Author: Andrew Brink <abrink27@gmail.com>
Date:   Wed Feb 10 04:02:15 2016 +0000

    schema.rb fixed with rollback

commit 50b1efb7b0d64ff285b07c93a6e16e0a81d0de72
Merge: 8abd8a7 16b325e
Author: Andrew Brink <abrink27@gmail.com>
Date:   Wed Feb 10 04:01:06 2016 +0000

    Merge branch 'develop' into AB/game-model

commit 8abd8a7fa0efbc2b884dcf9211b2b83e15466f18
Author: Andrew Brink <abrink27@gmail.com>
Date:   Wed Feb 10 03:59:02 2016 +0000

    schema.rb rollback

commit 240d778077c1d7934d5414e52f5fe58d5c9f867d
Author: Andrew Brink <abrink27@gmail.com>
Date:   Wed Feb 10 03:32:48 2016 +0000

    devise added and name field added

commit 74a3bbf3ea88cb77211918448504e720b08635f5
Author: dino217 <brob217@gmail.com>
Date:   Tue Feb 9 19:01:11 2016 -0800

    Set up models for Game and Pieces. Built associations between them.

commit 1298a56f39525f8dd9155307f521a06076c21bf3
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sun Feb 7 23:23:36 2016 +0000

    games model added

commit bd0dc31f26771d2fee5a8a424eb6feab3343a4a7
Author: Andrew Brink <abrink27@gmail.com>
Date:   Sun Feb 7 23:02:17 2016 +0000

    games controller added

commit 16b325ea2a8fad11d188df8e1ba5580e521d348b
Merge: 777505b ce52b7c
Author: Trevor Johnson <arubyrailsdev@gmail.com>
Date:   Mon Feb 8 09:22:19 2016 +1100

    Merge pull request #4 from RooknRolll/player-auth
    
    Added username to Players

commit ce52b7c13c813844167747b1012dfd3a71a2ac2f
Author: Nathan <nathangelliott@gmail.com>
Date:   Sat Feb 6 21:39:17 2016 +0000

    Added username to Players

commit 777505b6831355cc2c34f5cf7e46387244953e98
Merge: 6bd8e4e 43fc181
Author: Brandon <dino217@users.noreply.github.com>
Date:   Fri Feb 5 17:11:08 2016 -0800

    Merge pull request #3 from RooknRolll/player-auth
    
    Player auth

commit 6bd8e4e3b61894c502d2144c19136f144dcb7003
Merge: 1ee464f a6b7d66
Author: Brandon <dino217@users.noreply.github.com>
Date:   Fri Feb 5 16:06:01 2016 -0800

    Merge pull request #2 from RooknRolll/add-bootstrap
    
    Add bootstrap

commit 43fc181a564616216d0eee7f777a0bf2cc3c782b
Author: Nathan <nathangelliott@gmail.com>
Date:   Fri Feb 5 23:07:52 2016 +0000

    Added Devise for Player authentication

commit a6b7d6678a9d233e878910c545706c5b41347766
Author: Nathan <nathangelliott@gmail.com>
Date:   Fri Feb 5 21:52:16 2016 +0000

    Replaced application.css with application.scss

commit 0e6b10d75eb6450ee48d3a08f5aceb33b1a4d277
Author: Nathan <nathangelliott@gmail.com>
Date:   Fri Feb 5 21:42:14 2016 +0000

    Added Twitter Bootstrap 3

commit 1ee464f0dd3a34fe64cf1fccde162593d2256238
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Wed Feb 3 20:46:02 2016 +0000

    Added rails_12factor gem

commit 78d891090664cbc44e91789dbea58021ab5a904e
Author: ATJohnson <arubyrailsdev@gmail.com>
Date:   Wed Feb 3 20:41:08 2016 +0000

    Initial commit
