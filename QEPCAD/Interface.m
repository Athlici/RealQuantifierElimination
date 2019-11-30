(* ::Package:: *)

(* ::Text:: *)
(*ExportQEPCAD produces a text file that can be passed to the qepcad.sh script as input to QEPCAD.*)
(*\[Phi] is the input formula with quantifiers*)
(*u is the list and order of the free variables*)
(*s is the name of the export file*)


ExportQEPCAD[\[Phi]_,u_,s_]:=Module[{f},
f[HoldPattern[Exists[l_List,\[Psi]_]]]:={StringJoin["(E "<>ToString[#]<>")"&/@l,#],   Join[l,#2]}&@@f[\[Psi]];
f[HoldPattern[Exists[l_    ,\[Psi]_]]]:={StringJoin["(E "<>ToString[l]<>")"    ,#],Prepend[#2,l]}&@@f[\[Psi]];
f[HoldPattern[ForAll[l_List,\[Psi]_]]]:={StringJoin["(A "<>ToString[#]<>")"&/@l,#],   Join[l,#2]}&@@f[\[Psi]];
f[HoldPattern[ForAll[l_    ,\[Psi]_]]]:={StringJoin["(A "<>ToString[l]<>")"    ,#],Prepend[#2,l]}&@@f[\[Psi]];
f[HoldPattern[And[\[Psi]l__]]]:={StringJoin["[",StringRiffle[#," /\\ "],"]"],{}}&@@((f/@{\[Psi]l})\[Transpose]);
f[HoldPattern[ Or[\[Psi]l__]]]:={StringJoin["[",StringRiffle[#," \\/ "],"]"],{}}&@@((f/@{\[Psi]l})\[Transpose]);
f[HoldPattern[   Implies[\[Psi]l__]]]:={StringJoin["[",#[[1]]," ==> " ,#2[[1]],"]"],{}}&@@(f/@{\[Psi]l});
f[HoldPattern[Equivalent[\[Psi]l__]]]:={StringJoin["[",#[[1]]," <==> ",#2[[1]],"]"],{}}&@@(f/@{\[Psi]l});
f[x_==Root[g_,r_]]:={ToString[x]<>" = _root_"<>ToString[r]<>" "<>f[g[x]],{}};
f[g_>h_] :={f[ExpandAll[g-h]]<> ">0",{}};
f[g_<h_] :={f[ExpandAll[h-g]]<> ">0",{}};
f[g_>=h_]:={f[ExpandAll[g-h]]<>">=0",{}};
f[g_<=h_]:={f[ExpandAll[h-g]]<>">=0",{}};
f[g_==h_]:={f[ExpandAll[g-h]]<> "=0",{}};
f[g_!=h_]:={f[ExpandAll[g-h]]<>"/=0",{}};
f[g_]:=StringReplace[ToString[g,InputForm],{"*"->" "}];
Export[s<>".txt",With[{vr=Thread[#->StringDelete[#,{"[","]"}]]&[ToString/@Join[u,#2]]},
StringRiffle[{"["<>s<>"]","("<>StringRiffle[Last/@vr,","]<>")",ToString@Length[u],
StringReplace[#<>".",vr],"finish"," "},"\n"]]&@@f[\[Phi]]]]


(* ::Text:: *)
(*ImportQEPCAD turns the output of QEPCAD back into a Mathematica formula. It does not have any sort of error handling!*)
(*s is the string that is to be imported*)


ImportQEPCAD[s_]:=Module[{}(*{l=StringSplit[Import[s],"\n"]}*),
Print/@s[[-6;;-1]];
ToExpression[StringReplace[s[[-8]],{"["->"(","]"->")","/\\"->"&&","\\/"->"||"," = "->" == "}]]]


(* ::Text:: *)
(*RunQEPCAD combines Output and Input to simplify staying in Mathematica*)
(*\[Phi] is the input formula with quantifiers*)
(*u is the list and order of the free variables*)
(*s is the name of the export file*)


RunQEPCAD[\[Phi]_,u_,s_]:=Module[{out},
ExportQEPCAD[\[Phi],u,s];
out=ReadList["!sh qepcad.sh "<>s<>".txt",Record];
ImportQEPCAD[out]]


(* ::Text:: *)
(*QEPCADSimplify is a wrapper around RunQEPCAD with default file name tmp.*)
(*\[Phi] is the input formula with quantifiers*)
(*u is the list and order of the free variables*)


QEPCADSimplify[\[Phi]_,u_]:=RunQEPCAD[\[Phi],u,"tmp"]
