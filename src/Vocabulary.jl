module Vocabulary

export Word, Words

FuzzyWordString(a,b,c)=  ('*'^b) * a * ('*'^c)

#NOTE!!! 
#Don't forget to eventually move vocabulary into a json file!!!

#Each word is split into 4 components
#WORD: Semantic Representation of what syd understood something as (uppercase)
#Radical: A phonological approximation (lowercase)
#FrontFuzziness: Front Tolerance (of lip-smacking, gliding an initial vowel etc.)
#TrailFuzziness: Back Tolerance (of nasalizing etc.)

mutable struct Word
    WORD::String
    Radical::String
    FrontFuzziness::Int
    TrailFuzziness::Int
    FuzzyWordString::String

    function Word(a)
    new(uppercase(a), a, 2, 2, FuzzyWordString(a,2,2)) 
    end   

    function Word(a, c, d)
    new(uppercase(a), a, c, d, FuzzyWordString(a,c,d)) 
    end   

    function Word(a, b, c, d)
    new(a, b, c, d, FuzzyWordString(a,c,d)) 
    end   
end

Words = [Word("play"),Word("pause")]

end


