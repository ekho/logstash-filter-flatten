# encoding: utf-8

require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/flatten"

describe LogStash::Filters::Flatten do

  describe "flatten on non array should return origin value" do
    # The logstash config goes here.
    # At this time, only filters are supported.
    config <<-CONFIG
      filter {
        flatten {
          fields => ["field1"]
        }
      }
    CONFIG

    sample("field1" => "asdf") do
      insist { subject.get("field1") } == "asdf"
    end
  end

  describe "flatten on simple array should return origin array" do
    # The logstash config goes here.
    # At this time, only filters are supported.
    config <<-CONFIG
      filter {
        flatten {
          fields => ["field2"]
        }
      }
    CONFIG

    sample("field2" => [1,2,1,2,1,2,1,2, "string"]) do
      insist { subject.get("field2") } == [1,2,1,2,1,2,1,2, "string"]
    end
  end

  describe "flatten on array of arrays" do
    # The logstash config goes here.
    # At this time, only filters are supported.
    config <<-CONFIG
      filter {
        flatten {
          fields => ["field3"]
        }
      }
    CONFIG

    sample("field3" => [["a"], ["b"], ["c"], ["c"], ["d"]]) do
      insist { subject.get("field3") } == ["a", "b", "c", "c", "d"]
    end
  end

  describe "flatten recursive on array of arrays of arrays ... " do
    # The logstash config goes here.
    # At this time, only filters are supported.
    config <<-CONFIG
      filter {
        flatten {
          fields => ["field3"]
        }
      }
    CONFIG

    sample("field3" => [["a"], "b", [["c"], [["d"]], [[[[[[[[[[["e"]]]]]]]]]]]]]) do
      insist { subject.get("field3") } == ["a", "b", "c", "d", "e"]
    end
  end
end
