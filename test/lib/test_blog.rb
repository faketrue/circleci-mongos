require 'minitest/autorun'
require 'blog'

class TestBlog < Minitest::Test

  def test_with_shard_key
    blog = Blog.where(name: 'masahiro', user_id: 1)
        .find_and_modify(
          {'$set' => {name: 'masahiro', user_id: 1}},
          new: true,
          upsert: true,
        )

    assert_equal(false, blog.nil?)
  end

  def test_without_shard_key
    assert_raises do
      Blog.where(name: 'masahiro')
          .find_and_modify(
            {'$set' => {name: 'masahiro', user_id: 1}},
            new: true,
            upsert: true,
          )
    end
  end
end

