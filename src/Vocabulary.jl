module Vocabulary

export Word, Words

FuzzyWordString(a,b,c)=  ('*'^b) * a * ('*'^c)

#NOTE!!! 
#Don't forget to eventually move vocabulary into a json file!!!

#Each word is split into 5 components
#WORD: Semantic Representation of what syd understood something as (uppercase)
#Radical: A phonological approximation (lowercase)
#Tolerance: Variability allowed (increase for longer words)
#FrontFuzziness: Front Tolerance (of lip-smacking, gliding an initial vowel etc.)
#TrailFuzziness: Back Tolerance (of nasalizing etc.)

mutable struct Word
    WORD::String
    radical::String
    frontFuzziness::Int
    trailFuzziness::Int
    tolerance::Int
    fuzzyWordString::String

    function Word(a)
    new(uppercase(a), a, 2, 2, 2, FuzzyWordString(a,2,2)) 
    end   

    function Word(a, c, d)
    new(uppercase(a), a, c, d, 2, FuzzyWordString(a,c,d)) 
    end   

    function Word(a, b, c, d)
    new(a, b, c, d, 2, FuzzyWordString(a,c,d)) 
    end   

    function Word(a, b, c, d, e3)
    new(a, b, c, d, e, FuzzyWordString(a,c,d)) 
    end   
end

Words = [Word("play"),Word("pause")]

end


