# encoding: utf-8
# to_json2.rb
# author: dice2000
# original author: aoitaku
# https://gist.github.com/aoitaku/7822424
#

require 'jsonable'
require 'zlib'
require_relative 'rgss3'

begin
path = File.expand_path(ARGV[0])
targetPath = ARGV[1]
if targetPath
  targetPath = File.expand_path(targetPath)
end

p 'Read '+path

[
  'Data/Actors.rvdata2',
  'Data/Animations.rvdata2',
  'Data/Areas.rvdata2',
  'Data/Armors.rvdata2',
  'Data/Classes.rvdata2',
  'Data/CommonEvents.rvdata2',
  'Data/Enemies.rvdata2',
  'Data/Items.rvdata2',
  *Dir.glob(path+'/Data/Map[0-9][0-9][0-9].rvdata2'),
  'Data/MapInfos.rvdata2',
  'Data/Skills.rvdata2',
  'Data/States.rvdata2',
  'Data/System.rvdata2',
  'Data/Tilesets.rvdata2',
  'Data/Troops.rvdata2',
  'Data/Weapons.rvdata2'
].each do |rvdata|
  if rvdata[path]
  else
    rvdata = File.join(path,rvdata)
  end
  data = ''
  p 'Convert: '+rvdata
  begin
    File.open(rvdata, 'rb') do |file|
      data = Marshal.load(file.read)
      if data.is_a?(Array)
    	    data.each{ |d|
    	    	d.unpack_names if d != nil
    	    }
    		elsif data.is_a?(Hash)
    			if data.size != 0
    				data.each_value{|v|
    					v.unpack_names
    				}
    			end
    		else
    			data.unpack_names
      end
    end

    curDir = path+'/Data/'

    if targetPath
      curDir = targetPath
    end

    if !curDir.end_with?("/")
      curDir = curDir + '/'
    end
    unless Dir.exist?(curDir)
      Dir.mkdir(curDir)
    end
    File.open(curDir+File.basename(rvdata,'.rvdata2')+'.json', 'w') do |file|
        file.write(data.to_json)
    end
  rescue => error
      p error
      # p "Faild, code:"
      # p "err|file=#{rvdata}|errorclass=#{error.class}|error=#{error.message}"
    next
  end
  p 'complete!'
end
rescue => error
  p error
  p 'Failed to complete'
end
