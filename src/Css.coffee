
class Css
  light = "#ededed"
  dark  = "#bbb"
  shadow= "#ffffff"

  @CODE =
  """
<style>
.roofpig-button {
  font-family: Lucida Sans Unicode, Lucida Grande, sans-serif;
  font-weight: normal;
  font-style: normal;
  padding: 0;
  box-shadow: inset 0px 1px 0px 0px #{shadow};
  background-color: #{light};
  border: 1px solid #dcdcdc;
  outline: none;
  border-radius: 2px;
  text-indent: 0;
  display: inline-block;
  text-decoration: none;
  text-align: center;
  text-shadow: 1px 1px 0 #{shadow};
}
.roofpig-button-enabled {
  background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #{light}), color-stop(1, #{dark}));
  background: -moz-linear-gradient(center top, #{light} 5%, #{dark} 100%);
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#{light}', endColorstr='#{dark}');
}
.roofpig-button-enabled:hover {
  background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #{dark}), color-stop(1, #{light}));
  background: -moz-linear-gradient(center top, #{dark} 5%, #{light} 100%);
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#{dark}', endColorstr='#{light}');
}
.roofpig-button-enabled:active, .roofpig-button-fake-active {
  position: relative;
  top: 2px;
}

.roofpig-count {
  font-weight: normal;
  font-style: normal;
  color: black;
  text-align: right;
  float: right;
}

.roofpig-algtext {
  background-color: #eee;
  margin-bottom: 2px;
  font-weight: normal;
  font-style: normal;
  color: black;
}
.roofpig-past-algtext {
  background-color: #ff9;
}

.roofpig-help-button {
  font-size: 14px;
  height: 20px;
  width: 20px;
  position: absolute;
  right: 2px;
  top: 3px;

  color: #ddd;
  text-align: center;
  border-radius: 8px;
}
.roofpig-help-button:hover {
  color: black;
  background-color: rgba(220, 220, 220, 0.7);
}
.roofpig-help-button:active {
  background-color: #aaa;
}

.roofpig-help {
  position: absolute;
  top: -1px;
  white-space: nowrap;

  font-size: 10px;
  font-weight: normal;
  font-style: normal;
  color: black;
  text-align: left;
  background-color: rgba(255, 255, 255, 0.94);

  border: 1px solid #aaa;
  padding: 0 4px 4px 4px;
}
.roofpig-help div {
  margin: 2px 0;
}
.roofpig-help span {
  font-size: 11px;
  padding: 0 2px;
  background-color: #ddd;
}
</style>
    """