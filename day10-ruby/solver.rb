# part 1
lines = File.readlines('input.txt')

BRACKETS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>',
}

OPENING = BRACKETS.keys
CLOSING = BRACKETS.values

BRACKET_SCORE = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
}

INCOMPLETE_SCORE = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4,
}

def autocomplete_score(remaining_brackets)
    score = 0
    remaining_brackets.each do |bracket|
        score *= 5
        score += INCOMPLETE_SCORE[bracket]
    end
    return score
end

def invalid_bracket(line)
    stack = []
    line.each_char do |c|
        if OPENING.include?(c) 
            stack << BRACKETS[c]
        elsif CLOSING.include?(c)
            if stack.last == c
                stack.pop
            else
                return c, 0
            end
        end
    end

    return '', autocomplete_score(stack.reverse())
end

invalid_score = 0
autocmpl_score = []

p autocomplete_score(["]",")","}",">"])

lines.each do |line|
    invalid, auto = invalid_bracket(line)
    if invalid != ""
        invalid_score += BRACKET_SCORE[invalid]
    else
        autocmpl_score << auto
    end
end
   
p invalid_score
p autocmpl_score.sort[autocmpl_score.size / 2]