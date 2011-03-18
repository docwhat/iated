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

import java.util.LinkedHashMap;
import java.util.Map;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.docwhat.iated.AppState;
import org.docwhat.iated.EditSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Path("/edit/{token}/{id}")
public class EditTokenId {
    private static final Logger logger = LoggerFactory.getLogger(EditTokenId.class);

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response GET(@PathParam("token") String token,
                        @PathParam("id")    Long   id) {

        EditSession session = AppState.INSTANCE.getEditSession(token);
        Long change_id = session.getChangeId();

        boolean has_changed = !change_id.equals(id);

        logger.debug("--EditTokenId");
        logger.debug("Session: " + token);
        logger.debug("ChangeId: " + change_id);
        logger.debug("Has Changed: " + has_changed);

        if (has_changed) {
            Map<String, String> response = new LinkedHashMap<String, String>();
            response.put("id",   change_id.toString());
            response.put("text", session.getText());

            return Response.ok(response, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.notModified().build();
        }
    }
}
