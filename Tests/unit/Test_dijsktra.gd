extends "res://addons/gut/test.gd"
"""
"""

var map : DijkstraMap
var res
const _len = 5

func before_each():
	gut.p("#-----Start Test-----#")
	map = DijkstraMap.new()
	map.add_point(0,0)
	map.add_point(1,0)
	map.add_point(2,0)
	
func after_each():
	gut.p("#------End Test------#")

func test_add_point():
	res = map.add_point(3,0)
	assert_eq(res,OK,"you can add a point once")
	res = map.add_point(3,0)
	assert_eq(res,FAILED,"but not twice")


func test_has_points():
	assert_true(map.has_point(1))
	assert_true(map.has_point(2))
	assert_false(map.has_point(3))


func test_connect_points():
	gut.p("not reversed")
	res = map.connect_points(1,2,1.0,false)
	assert_eq(res,OK,"connected 1 -> 2 succesfully")
	
	map.recalculate(1,{})
	
	res = map.get_cost_at_point(1)
	assert_eq(res,1.0,"cost corresponds")
	
	gut.p(map.get_cost_map())
	
	gut.p("reversed :")
	
	res = map.connect_points(2,1,5.0,false)
	assert_eq(res,OK,"reverse connection worked")
	
	map.recalculate(1,{"reversed":true})

	assert_eq(map.get_cost_at_point(2),5.0,"the cost is of the reversed connection")
	gut.p(map.get_cost_map())


func test_disable_enables():
	map.add_point(3,0)
	res = map.connect_points(1,2,1.0,false)
	assert_eq(res,OK)
	res = map.connect_points(2,3,1.0,false)
	assert_eq(res,OK)
	
	gut.p("recalculate")
	map.recalculate(1,{})
	gut.p("end_recalculate")
	
	assert_eq(map.get_cost_at_point(3),2.0,"point is enabled, you can go from 1 to 3 via 2")
	map.disable_point(2)
	map.recalculate(1,{})
	
	assert_eq(map.get_cost_at_point(3),INF,"2 is disabled")
	map.enable_point(2)
	map.recalculate(1,{})
	
	assert_eq(map.get_cost_at_point(3),2.0,"back to ok")
	
	
func test_connect_point_unilateral():
	
	map.connect_points(1,2,1.0,false)
	map.connect_points(2,3,1.0,false)
	
	
	assert_true(map.has_point(1))
	assert_true(map.has_point(2))
	
	assert_false(map.is_point_disabled(1))
	assert_false(map.is_point_disabled(2))
	
	assert_true(map.has_connection(1,2),"1 to 2 should be connected")
	assert_false(map.has_connection(2,1),"reverse connection doesnt exist")
	
	map.recalculate(1,{})
	assert_eq(map.get_cost_at_point(2),1.0)
	
func test_connect_point_bilateral():
	pending()
	map.connect_points(1,2,1.0,true)
	map.recalculate_for_target(1,INF,false)
	
	assert_true(map.has_point(1))
	assert_true(map.has_point(2))
	
	assert_false(map.is_point_disabled(1))
	assert_false(map.is_point_disabled(2))
	
	assert_true(map.has_connection(1,2),"1 to 2 should be connected")
	assert_true(map.has_connection(2,1),"2 to 1 connected")
	
	gut.p(map.get_cost_map())
	assert_eq(map.get_cost_at_point(2),1.0)
	assert_eq(map.get_cost_at_point(1),0.0)

func test_create_as_grid():
	pending("not decided in rust code")

