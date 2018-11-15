class List
  def initialize(arr)
    @arr = arr
  end
  def each
    i = 0
    while i < @arr.length
      yield @arr[i]
      i += 1
    end
  end
end