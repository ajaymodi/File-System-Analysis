class Acquire < Shoes
  url '/acquire', :acquire
  # url '/incidents/(\d+)', :incident

  def acquire
    # incident(0)
  end

  # INCIDENTS = YAML.load_file('samples/class-book.yaml')

  # def table_of_contents
  #   toc = []
  #   INCIDENTS.each_with_index do |(title, story), i|
  #     toc.push "(#{i + 1}) ",
  #       link(title, click: "/incidents/#{i}"),
  #       " / "
  #   end
  #   toc.pop
  #   span *toc
  # end

  # def incident(num)
  #   num = num.to_i
  #   background white
  #   stack margin: 10, margin_left: 190, margin_top: 20 do
  #     banner "Incident", margin: 4
  #     para strong("No. #{num + 1}: #{INCIDENTS[num][0]}"), margin: 4
  #   end
  #   flow width: 180, margin_left: 10, margin_top: 0 do
  #     para table_of_contents, size: 8
  #   end
  #   stack margin: 10, margin_top: 0 do
  #     INCIDENTS[num][1].split(/\n\n+/).each do |p|
  #       para p
  #     end
  #   end
  # end
end

Shoes.app title: "Post-Acquisition process", width: 450, height: 450 do
  background "#DFA"
  stack(margin: 30) do
    para "Please give the full path of the raw image", align: 'center'
    flow do
      edit_line
      button "OK"
    end
    image "Or.png" , align: 'center'
    para "Please click on the open", align: 'center'
    flow do
      edit_line
			button "Open" do 
		    file = ask_open_file
		    store = YAML::Store.new file
		    store.transaction(true) do
		      @title.text = store['title']
		      @para.text = store['para']
		    end
	    end
    end
  end
end
