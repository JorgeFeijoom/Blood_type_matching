class List
  def initialize(arr)
    @arr = arr
  end
  def iterator
    i = 0
    while i < @arr.length
      yield @arr[i]
      i += 1
    end
  end
end