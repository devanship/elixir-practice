defmodule Practice.Fac do

# https://rosettacode.org/wiki/Prime_decomposition#Elixir
	def factor(x) do
		# [1,2,x, []]
		factor(x, 2, [])
	end

	def factor(x, y, acc) when x < y * y do 
		acc ++ [x]
		|> Enum.sort()
	end

	def factor(x, y, acc) when rem(x, y) == 0 do
		factor(div(x, y), y, [y | acc])
	end

	def factor(x, y, acc) do
		factor(x, y + 1, acc)
	end
end

