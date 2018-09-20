defmodule Practice.Pal do
	def palindrome?(str) when is_binary(str) do
		str2 = String.reverse(str)
		String.equivalent?(str, str2)
	end
end
