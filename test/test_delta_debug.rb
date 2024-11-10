# frozen_string_literal: true

require "test_helper"

class TestDeltaDebug < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DeltaDebug::VERSION
  end

  def test_array_example
    input = (1..8).to_a
    harness = ->(v) { ([1,7,8] - v).empty? }

    result = DeltaDebug.new(harness).ddmin(input)
    assert_equal [1, 7, 8], result
  end

  def test_html_example
    # From https://www.st.cs.uni-saarland.de/papers/tse2002/tse2002.pdf
    input = '<SELECT NAME="priority" MULTIPLE SIZE=7>'
    harness = ->(v) { /<SELECT.*>/i.match?(v) }

    result = DeltaDebug.new(harness).ddmin(input)
    assert_equal "<SELECT>", result
  end

  def test_larger_html_example
    # From https://www.st.cs.uni-saarland.de/papers/tse2002/tse2002.pdf
    input = <<~HTML
    <td align=left valign=top>
    <SELECT NAME="op sys" MULTIPLE SIZE=7>
    <OPTION VALUE="All">All<OPTION VALUE="Windows 3.1">Windows 3.1<OPTION VALUE="Windows 95">Windows 95<OPTION VALUE="Windows
    98">Windows 98<OPTION VALUE="Windows ME">Windows ME<OPTION VALUE="Windows 2000">Windows 2000<OPTION VALUE="Windows
    NT">Windows NT<OPTION VALUE="Mac System 7">Mac System 7<OPTION VALUE="Mac System 7.5">Mac System 7.5<OPTION VALUE="Mac
    System 7.6.1">Mac System 7.6.1<OPTION VALUE="Mac System 8.0">Mac System 8.0<OPTION VALUE="Mac System 8.5">Mac System
    8.5<OPTION VALUE="Mac System 8.6">Mac System 8.6<OPTION VALUE="Mac System 9.x">Mac System 9.x<OPTION VALUE="MacOS X">MacOS
    X<OPTION VALUE="Linux">Linux<OPTION VALUE="BSDI">BSDI<OPTION VALUE="FreeBSD">FreeBSD<OPTION VALUE="NetBSD">NetBSD<OPTION
    VALUE="OpenBSD">OpenBSD<OPTION VALUE="AIX">AIX<OPTION VALUE="BeOS">BeOS<OPTION VALUE="HP-UX">HP-UX<OPTION
    VALUE="IRIX">IRIX<OPTION VALUE="Neutrino">Neutrino<OPTION VALUE="OpenVMS">OpenVMS<OPTION VALUE="OS/2">OS/2<OPTION
    VALUE="OSF/1">OSF/1<OPTION VALUE="Solaris">Solaris<OPTION VALUE="SunOS">SunOS<OPTION VALUE="other">other</SELECT>
    </td>
    <td align=left valign=top>
    <SELECT NAME="priority" MULTIPLE SIZE=7>
    <OPTION VALUE="--">--<OPTION VALUE="P1">P1<OPTION VALUE="P2">P2<OPTION VALUE="P3">P3<OPTION VALUE="P4">P4<OPTION
    VALUE="P5">P5</SELECT>
    </td>
    <td align=left valign=top>
    <SELECT NAME="bug severity" MULTIPLE SIZE=7>
    <OPTION VALUE="blocker">blocker<OPTION VALUE="critical">critical<OPTION VALUE="major">major<OPTION
    VALUE="normal">normal<OPTION VALUE="minor">minor<OPTION VALUE="trivial">trivial<OPTION VALUE="enhancement">enhancement</SELECT>
    </tr>
    </table>
    HTML
    harness = ->(v) { /<SELECT.*>/i.match?(v) }

    result = DeltaDebug.new(harness).ddmin(input)
    assert_equal "<SELECT>", result
  end

  def test_single_input
    input = "foobar"
    harness = ->(x) { x.include?("a") }

    result = DeltaDebug.new(harness).ddmin(input)
    assert_equal "a", result
  end

  def test_empty_input
    input = "asdfasdf"
    harness = ->(v) { true } # always fails

    result = DeltaDebug.new(harness).ddmin(input)
    assert_equal "", result
  end
end
