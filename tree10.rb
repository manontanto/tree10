#!/usr/bin/ruby
# tree
# manontanto
# Display File Tree with size
#
def get_all_size
  s_old = 0
  Dir.glob($dir + '/**/*').each { | a_file |
    dn = File.dirname(a_file)
    s  = File.lstat(a_file).size.to_i
    $file_size[ a_file ] = s
    $dir_size[ dn ] = (s_old = $dir_size[ dn ]) ? s_old + s : s
  }
end

def arrange(plist)
  list = []
  wl = plist.clone
  wl.each { | entory |
    if FileTest.directory?(entory) then
      list.push(entory)
      plist.delete(entory)
    end
  }
  plist = sort_by_size(plist) + list
end

def sort_by_size(flist)
  list = flist
  list.sort {| a, b | $file_size[b] <=> $file_size[a] }
end

def follow_dir
    plist = Dir.glob($dir + '/*')
    plist = arrange(plist)
    puts $dir
    disp_dir_total($dir)
    plist.each { | entory |
      $tab_count = 0
      disp_dir(entory)
    }
end

def disp_dir( a_entory)
    if FileTest.file?(a_entory) then
      disp_file(a_entory)
    else
      disp_file(a_entory)
      $tab_count += 1
      disp_dir_total(a_entory)
      plist = arrange(Dir.glob(a_entory + '/*'))
      plist.each { | b_entory |
        disp_dir(b_entory)
      }
      $tab_count -= 1
    end
end

def disp_dir_total(name)
    if $tab_count >10 then
      puts "Over 10 Column. <STOP>"
      exit
    end
    print "   " * $tab_count
    printf("|---%6d:---\n", $dir_size[name])
end
def disp_file(name)
    print "   " * $tab_count
    printf("|---%6d:%-20s\n", $file_size[name], File.basename(name))
end

def check_usage
  unless ARGV.length < 2 && FileTest.directory?($dir)
    puts "Usage: tree [dir]"
    exit
  end
end
def init
    if ARGV.length == 0 then
      $dir = Dir.pwd
    else
      $dir = File.expand_path(ARGV[0])
    end
    check_usage
    $file_size = {} #{:file_name=>:file_size}
    $dir_size = {} #{:dir_name=>:dir_total_size}
    $dir_size.default = 0
    $tab_count = 0 # counter for left_spaces
end

if $0 == __FILE__
    init
    get_all_size
    follow_dir
end
