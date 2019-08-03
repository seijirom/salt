        
# Enter your Ruby code here
module MyMacro
 
  include RBA

  app = Application.instance
  mw = app.main_window
  unless lv = mw.current_view
    raise "Shape Statistics: No view selected"
  end
  cell = lv.active_cellview.cell
  layout = cell.layout
  if outline = layout.find_layer('OUTLINE')
    layout.delete_layer(outline)
  else
    raise "DEF/LEF already converted!"
  end
  ml3_src = layout.layer(10,0)
  ml3_dst = layout.layer(12,0)
  layout.move_layer(ml3_src, ml3_dst) # ML3
  via2_src = layout.layer(9,0)
  via2_dst = layout.layer(11,0)
  layout.move_layer(via2_src, via2_dst) # via2
  ml2_src = layout.layer(8,0)
  ml2_dst = layout.layer(10,0)
  layout.move_layer(ml2_src, ml2_dst) # ML2
  via1_src = layout.layer(7,0)
  via1_dst = layout.layer(9,0)
  layout.move_layer(via1_src, via1_dst) # via1
  ml1_src = layout.layer(6,0)
  ml1_dst = layout.layer(8,0)
  layout.move_layer(ml1_src, ml1_dst) # ML1

  ml1label = layout.find_layer(6,1)
  ml1pin = layout.find_layer(6,2)
  ml1obs = layout.find_layer(6,3)
  layout.move_layer(ml1label, ml1_dst) if ml1label
  layout.move_layer(ml1pin, ml1_dst) if ml1pin
  layout.move_layer(ml1obs, ml1_dst) if ml1obs

  ml2label = layout.find_layer(8,1)
  ml2pin = layout.find_layer(8,2)
  ml2obs = layout.find_layer(8,3)
  layout.move_layer(ml2label, ml2_dst) if ml1label
  layout.move_layer(ml2pin, ml2_dst) if ml1pin
  layout.move_layer(ml2obs, ml2_dst) if ml1obs

  ml3label = layout.find_layer(10,1)
  ml3pin = layout.find_layer(10,2)
  layout.move_layer(ml3label, ml3_dst) if ml3label
  layout.move_layer(ml3pin, ml3_dst) if ml3pin

  lib = Library::library_by_name('OpenRule1um')
  cell.each_inst{|inst|
    if cell = lib.layout.cell(inst.cell.name) 
      proxy_index = layout.add_lib_cell(lib, cell.cell_index)
      inst.cell = layout.cell(proxy_index)
    end
  }
  lv.remove_unused_layers
end