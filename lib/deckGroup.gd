DeclareAttribute("DeckGroup", IsOrigami);
DeclareAttribute("IsNormalOrigami", IsOrigami);
DeclareOperation("IsElementOfDeckGroup", [IsOrigami, IsPerm]);
DeclareOperation("AsNormalStoredOrigami", [IsOrigami]);
