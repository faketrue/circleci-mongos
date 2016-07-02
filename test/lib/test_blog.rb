require 'minitest/autorun'
require 'blog'

class TestBlog < Minitest::Test

  def test_sample
    blog = Blog.where(name: 'masahiro')
        .find_and_modify(
          {'$set' => {name: 'masahiro', user_id: 1}},
          new: true,
          upsert: true,
        )

    assert_equal(false, blog.nil?)
  end
end

