class File
  def each_chunk(chunk_size = 10000000)
    yield read(chunk_size) until eof?
  end
end
