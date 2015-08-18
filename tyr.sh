#!/bin/sh
exec /valhalla/tyr/tyr_simple_service /valhalla/tyr/conf/valhalla.json >> /var/log/tyr.log 2>&1
