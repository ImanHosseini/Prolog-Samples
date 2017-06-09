
acceptFSE(End,_,End,[]).
acceptFSE(Start,Transitions,End,[H|T]):-
    trans(Start,X,epsilon,Transitions),
    acceptFSE(X,Transitions,End,[H|T]),!;
    trans(Start,X,H,Transitions),
    acceptFSE(X,Transitions,End,T),!.
acceptFS(Start,Transitions,[H|T],Input):-
    acceptFSE(Start,Transitions,H,Input),!;
    acceptFS(Start,Transitions,T,Input),!.
accepts([H|T],Transitions,AcceptNodes,Input):-
    acceptFS(H,Transitions,AcceptNodes,Input),!;
    accepts(T,Transitions,AcceptNodes,Input),!.
	
	trans(Src,Dst,Input,[H|T]):-
    H = (Src,Input,Dst),
    Input \= epsilon,!;
    H = (Src,Input,Dst),
    Src \= Dst,!;
    trans(Src,Dst,Input,T).