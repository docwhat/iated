/*
 * IATed -- It's All Text! Editor Daemon
 * Copyright (C) 2010,2011  Christian Höltje
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.docwhat.iated.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * The /ping resource.
 * @author Christian Höltje
 */
@Path("/ping")
public class Ping {

    @GET
    @Produces("text/plain")
    public String ping() {
        return "pong";
    }
}
