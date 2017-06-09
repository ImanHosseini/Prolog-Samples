element_at(X,[X|_],1).
element_at(X,[_|L],K) :- element_at(X,L,K1), K is K1 + 1.
operand(1,X,Z) :- arg(1,X,Z).
operand(2,X,Z) :- arg(2,X,T), arg(1,T,Z).
operand(3,X,Z) :- arg(2,X,T), arg(2,T,Y), arg(1,Y,Z).
operand(4,X,Z) :- arg(2,X,T), arg(2,T,Y), arg(2,Y,Z).

operandd(1,X,Z) :- arg(1,X,Z).
operandd(2,X,Z) :- arg(2,X,T),arg(1,T,Z).
operandd(3,X,Z) :- arg(2,X,T),arg(2,T,Z).
%codop(0,X,Z) :- arg(1,X,Z).
%codop(C,X,Z) :- decr(C,Cm),codop(Cm,X,Z).

list_length([]     , 0 ).
list_length([_|Xs] , L ) :- list_length(Xs,N) , L is N+1 .

%increment  : X1 <- X+1
incr(X,X1) :- X1 is X+1.
decr(X,X1) :- X1 is X-1.


%machine(Data,Code,FinalData) :- list_length(Code,Le), write(Le), machine(Data,Code,FinalData,0).

%machine(Data,Code,FinalData,Step) :- list_length(Code,Le), Step>Le.

%add(FinalData1,FinalData2,Op1,Op2,Op3) :- integer(Op1), integer(Op2),Ans is Op1+Op2,chngval(FinalData1,FinalData2,Op3,Ans).

addf(FinalData1,FinalData2,Instr):- operand(2,Instr,Op1),operand(3,Instr,Op2),operand(4,Instr,Op3),add(FinalData1,FinalData2,Op1,Op2,Op3).
add(FinalData1,FinalData2,Op1,Op2,Op3) :- resolve_var(FinalData1,Op1,Opp1),resolve_var(FinalData1,Op2,Opp2),Ans is Opp1+Opp2,chngval(FinalData1,FinalData2,Op3,Ans).
subf(FinalData1,FinalData2,Instr):- operand(2,Instr,Op1),operand(3,Instr,Op2),operand(4,Instr,Op3),sub(FinalData1,FinalData2,Op1,Op2,Op3).
sub(FinalData1,FinalData2,Op1,Op2,Op3) :- resolve_var(FinalData1,Op1,Opp1),resolve_var(FinalData1,Op2,Opp2),Ans is Opp1-Opp2,chngval(FinalData1,FinalData2,Op3,Ans).
multf(FinalData1,FinalData2,Instr):- operand(2,Instr,Op1),operand(3,Instr,Op2),operand(4,Instr,Op3),mult(FinalData1,FinalData2,Op1,Op2,Op3).
mult(FinalData1,FinalData2,Op1,Op2,Op3) :- resolve_var(FinalData1,Op1,Opp1),resolve_var(FinalData1,Op2,Opp2),Ans is Opp1*Opp2,chngval(FinalData1,FinalData2,Op3,Ans).
assignf(F1,F2,Instr):-operandd(2,Instr,Op1),operandd(3,Instr,Op2),assign(F1,F2,Op1,Op2).
assign(FinalData1,FinalData2,Op1,Op2) :- resolve_var(FinalData1,Op1,Opp1),chngval(FinalData1,FinalData2,Op2,Opp1).
biggerf(F1,F2,Instr):-operand(2,Instr,Op1),operand(3,Instr,Op2),operand(4,Instr,Op3),bigger(F1,F2,Op1,Op2,Op3).
bigger(FinalData1,FinalData2,Op1,Op2,Op3) :-resolve_var(FinalData1,Op1,Opp1),resolve_var(FinalData1,Op2,Opp2),(Opp1>Opp2->chngval(FinalData1,FinalData2,Op3,1);chngval(FinalData1,FinalData2,Op3,0)).
lessf(F1,F2,Instr):-operand(2,Instr,Op1),operand(3,Instr,Op2),operand(4,Instr,Op3),less(F1,F2,Op1,Op2,Op3).
less(FinalData1,FinalData2,Op1,Op2,Op3) :- resolve_var(FinalData1,Op1,Opp1),resolve_var(FinalData1,Op2,Opp2),(Opp1<Opp2->chngval(FinalData1,FinalData2,Op3,1);chngval(FinalData1,FinalData2,Op3,0)).
jmp(Data,Instr,NStep) :- arg(2,Instr,Adr),resolve_var(Data,Adr,X), NStep is X. 
jnz(Data,Instr,NStep,Step) :- operandd(2,Instr,Cdn),resolve_var(Data,Cdn,Cdnn),operandd(3,Instr,Adr),resolve_var(Data,Adr,X), ((Cdnn==0)-> NStep is Step+1;NStep is X).
jz(Data,Instr,NStep,Step) :- operandd(2,Instr,Cdn),resolve_var(Data,Cdn,Cdnn),operandd(3,Instr,Adr),resolve_var(Data,Adr,X), ((Cdnn==0)-> NStep is X;NStep is Step+1).

%imm or register? resolve it sucka!
resolve_var(Fd,X,Y) :- integer(X), Y is X, !.
resolve_var(Fd,X,Y) :- getvar(Fd,X,Y),!.

%get register K and put it in V, L is the data
%getvar([],K,V).
getvar([H|T],K,V) :- arg(1,H,D1),((D1==K)->arg(2,H,V);getvar(T,K,V)).  

%change a register
chngval([],[],_,_).
chngval([H|T],[X|Y],FV,SV) :- arg(1,H,D1),((D1==FV)->(X=(FV,SV))  ;copy(X,H)),chngval(T,Y,FV,SV).  
copy(H,H).

machine(Data,Code,FinalData):-copy(Data,CurD),machine(Data,Code,FinalData,0,CurD).
machine(Data,Code,FinalData,Step,CurData) :-incr(Step,RStep),element_at(Instr,Code,RStep),((Instr==halt;Instr==[halt])->copy(CurData,FinalData);(execute_inst(CurData,NData,Instr,Step,NStep),machine(Data,Code,FinalData,NStep,NData))).
%machine(CurData,Code,FinalData,Step) :-incr(Step,RStep),arg(RStep,Code,Instr),Instr==halt,copy(CurData,FinalData).

%machine(Data,Code,FinalData,0) :- copy(Data,ND),machine(Data,Code,ND,0).
%machine(Data,Code,FinalData,Step) :- incr(Step,RStep),arg(RStep,Code,Instr),Instr==halt.
%machine(OData,Code,FinalData,Step) :- incr(Step,RStep),arg(RStep,Code,Instr),execute_inst(OData,NData,Instr,RStep,NSetp),machine(NData,Code,FinalData,NStep).
%machine(Data,Code,FinalData,Step) :- write(Step), incr(Step,Step1), machine(Data,Code,FinalData,Step1).



% A generic switch 
switch(X, [Val:Goal|Cases]) :-
    ( X=Val ->
        call(Goal)
    ;
        switch(X, Cases)
    ).

% switch(a,[a:write(this),b]).
test(X):- switch(a,[a:write(this),b]).
execute_inst(Dat1,Dat2,Instr,Step,NStep) :- arg(1,Instr,Opcode),switch(Opcode,[add:(addf(Dat1,Dat2,Instr),incr(Step,NStep)),sub:(subf(Dat1,Dat2,Instr),incr(Step,NStep)),
mult:(multf(Dat1,Dat2,Instr),incr(Step,NStep)),bigger:(biggerf(Dat1,Dat2,Instr),incr(Step,NStep)),less:(lessf(Dat1,Dat2,Instr),incr(Step,NStep))),assign:(assignf(Dat1,Dat2,Instr),incr(Step,NStep)),
jmp:(jmp(Dat1,Instr,NStep),copy(Dat2,Dat1)),jnz:(jnz(Dat1,Instr,NStep,Step),copy(Dat2,Dat1)),jz:(jz(Dat1,Instr,NStep,Step),copy(Dat2,Dat1))]).












