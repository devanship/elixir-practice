defmodule Practice.Calc do

  def calc(expr) do
    expr
    |> String.split()
    |> to_postfix([], [])
    |> eval([])
  end

  @precedence %{
    "+"=> 0, 
    "-"=> 0, 
    "/"=> 1, 
    "*"=> 1
  }

    def is_op(char) do
        Enum.member?(["*", "/", "+", "-"], char)
    end

  #https://rosettacode.org/wiki/Determine_if_a_string_is_numeric#Elixir
    def is_num(char) when is_binary(char) do
        case Float.parse(char) do
            {_num, ""} -> true
            _ -> false
        end
    end
    
    # https://codeburst.io/conversion-of-infix-expression-to-postfix-expression-using-stack-data-structure-3faf9c212ab8
    def to_postfix(expr, op, acc) do
        cond do
          length(expr) == 0 ->
            if length(op) > 0 do
              to_postfix(expr, Enum.drop(op, -1), acc ++ Enum.take(op, -1))
            else
              acc
            end

           is_op(Enum.at(expr, 0)) ->
            expr_stack = Enum.drop(expr, 1)
            char = Enum.at(expr, 0)
            if length(op) != 0 do
                if @precedence[char] <= @precedence[Enum.at(op, -1)] do
                    to_postfix(expr, Enum.drop(op, -1), acc ++ Enum.take(op, -1))
                else 
                    to_postfix(expr_stack, op ++ [char], acc)
                end
            else
                to_postfix(expr_stack, op ++ [char], acc)
            end

          is_num(Enum.at(expr, 0)) ->
            expr_stack = Enum.drop(expr, 1)
            char = String.to_integer(Enum.at(expr, 0))
            to_postfix(expr_stack, op, acc ++ [char])
          end
    end

    def eval(expr, acc) do
        cond do 
            length(expr) == 0 ->
                Enum.at(acc, 0)

            not is_op(Enum.at(expr, 0)) ->
                expr_stack = Enum.drop(expr, 1)
                char = Enum.at(expr, 0)
                eval(expr_stack, acc ++ [char])
            
            is_op(Enum.at(expr, 0)) ->
                handleOps(expr, acc)
        end
    end

    def handleOps(expr, acc) do
        x = Enum.at(acc, -2)
        y = Enum.at(acc, -1)
        expr_stack = Enum.drop(expr, 1)
        char = Enum.at(expr, 0)
        cond do 
            char == "*" ->
                acc =Enum.drop(acc, -1)
                acc = Enum.drop(acc, -1) ++ [x * y]
                eval(expr_stack, acc)
            char == "/" ->
                acc =Enum.drop(acc, -1)
                acc = Enum.drop(acc, -1) ++ [div(x,y)]
                eval(expr_stack, acc)
            char == "+" ->
                acc =Enum.drop(acc, -1)
                acc = Enum.drop(acc, -1) ++ [x + y]
                eval(expr_stack, acc)
            char == "-" ->
                acc =Enum.drop(acc, -1)
                acc = Enum.drop(acc, -1) ++ [x - y]
                eval(expr_stack, acc)
        end 
    end

end
