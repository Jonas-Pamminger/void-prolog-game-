:- dynamic i_am_at/1, at/2, holding/1.

:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)).

:- discontiguous go/1, look/0, take/1, drop/1.

i_am_at(droneDock1).

path(droneDock1, e, hall1).
path(hall1, w, droneDock1).
path(hall1, s, hall2).
path(hall2, n, hall1).
path(hall2, s, hall3).
path(hall2, w, mainDock).
path(mainDock, e, hall2).



path(hall2, e, generatorDoor).
path(generatorDoor, w, hall2).

path(generator, w, generatorDoor).
path(generatorDoor, e, generator) :- holding(fuse) , holding(fuseCase).
path(generatorDoor, e, generator) :- write('You need a fuse and a fuse case to open the door'), nl, fail.


path(hall3, n, hall2).
path(hall3, w, droneDock2).
path(droneDock2, e, hall3).
path(generator, e, dinningRoom).
path(dinningRoom, w, generator).
path(generator,n,storageRoom).
path(storageRoom, s, generator).
path(dinningRoom, n, kitchen).
path(kitchen, s, dinningRoom).



path(dinningRoom, s, fire).
path(fire, n, dinningRoom).

path(livingQuarters, n, fire).
path(fire, s, livingQuarters) :- holding(fireExtinguisher).
path(fire, s, livingQuarters) :- write('You need a fire extinguisher to put out the fire'), nl.


path(livingQuarters, e, lockerRoom).
path(lockerRoom, w, livingQuarters).
path(dinningRoom, e, conferenceRoom).
path(conferenceRoom, w, dinningRoom).
path(conferenceRoom, e, mainBridge).
path(mainBridge, w, conferenceRoom).

at(fuse, droneDock2).
at(fuseCase, hall1).
at(fireExtinguisher, storageRoom).

/* These rules describe how to pick up an object. */

take(X) :-
        holding(X),
        write('You''re already holding it!'),
        !, nl.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('OK.'),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('OK.'),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        /*write('You are in '),
        write(Here), nl,*/
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        !, look.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* This rule tells how to die. */

die :-
        finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.             -- to start the game.'), nl,
        write('n.  s.  e.  w.     -- to go in that direction.'), nl,
        write('take(Object).      -- to pick up an object.'), nl,
        write('drop(Object).      -- to put down an object.'), nl,
        write('look.              -- to look around you again.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(droneDock1) :-
    write('You are in Drone Dock 1. You seem to have fallen asleep at your desk, something seems to be off tho. you''ve awoken with a slight headache. Your place is a mess.'),
    write('The drone you were fixing seems to just lie there on the ground, with all of it previously neatly placed technical parts scattered everywhere. What a piece of work.'),
    write('You decide to slowly stand up, even with that headache of yours, you should get to the bridge and inform yourself of what happend.'), nl.

describe(hall1) :-
    write('You are in a narrow hallway. There is a fuse case on the wall.'), nl.

describe(hall2) :-
    write('You find yourself in another hallway. It stretches out in front of you.'), nl.

describe(hall3) :-
    write('You are in a long corridor. The walls are lined with blinking lights.'), nl.

describe(mainDock) :-
    write('You enter the main dock. It is.. empty? No one seems to be loading up any ships, on secound thought, all of the ships seem to have... departed?'), nl.

describe(generator) :-
    write('You arrive at the generator room. It hums with energy. No engineers seem to be around tho. Just you and the hum.'), nl.

describe(generatorDoor) :-
    write('You are at the door to the generator room.'), nl.

describe(dinningRoom) :-
    write('You step into the dining room. Tables are set for a meal, but no one is here.'), nl.

describe(kitchen) :-
    write('You enter the kitchen. Food Items are scattered on the ground, nothing of use tho, chef seems to be missing. Weird, he usually never leaves his post.'), nl.

describe(livingQuarters) :-
    write('You step into the living quarters. The rooms are small but cozy. On the wall is a poster, containing a chibby cat in an austronaut suit. Under it is a motto: "KEEP CALM".'),
    write('You find a picture containing you and the rest of the crew, you remember the smiles they had on they''re faces when they were first introduced to they''re new vessel. But'),
    write('that was years ago. still, you remember the day the crew was assembled fondly, and you''ll never forget the family you''ve forged along the way.'), nl.

describe(lockerRoom) :-
    write('You are in the locker room. Rows of lockers line the walls. The spacesuits usually laying in there which haven''t been used for ages are all gone.'),
    write('Only yours remains. You do remember tho that it''s broken. You remember the day you went out to fix a sattelite and your front shield cracked, you were lucky the'),
    write('safety drones cought wind of your situation and dragged you back into the airlock. Your suit hasn''t been repaired to this day.'), nl.

describe(conferenceRoom) :-
    write('You enter the conference room. A large round table dominates the center. Yet no one is currently having a seat.'), nl.

describe(mainBridge) :-
    write('You finally arrive at the main bridge, but no one is here. It is quite dark, there are shards of glass covering the floor. You guess the lights were knocked out, how, you have no Idea.'),
    write('There is one thing only which lights up the bridge, the big screen in the middle, displaying the current situation all over the ship. You take a look at whats going on and horror starts to arise'),
    write('"SHIP OXYGEN LEVEL: 3% WARNING, ALL CREW ON BOARD IMMEDIATLY PUT ON YOUR SUITS, SHIP IN CRITICAL CONDITION, LEAVE THE SHIP BY ANY MEANS NECESSARY"'),
    write('You look at the ships integrity system and realize that half of the ship is utterly destroyed. You start connecting the dots, and then it hits you. All available space shuttles have long departed...'), die, nl.

describe(storageRoom) :-
    write('You are in a storage room. Various items are stacked on shelves.'), nl.

    describe(droneDock2):-
    write('You are in Drone Dock 2'), nl.
